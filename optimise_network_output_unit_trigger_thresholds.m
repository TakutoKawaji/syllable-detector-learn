function [ optimal_thresholds ] = optimise_network_output_unit_trigger_thresholds(...
        testout, ...
        tstep_of_interest_ds, ...
        FALSE_POSITIVE_COST, ...
        timestep_length, ...
        time_window_ds);

% Search for optimal thresholds given false-positive vs
% false-negagive weights (the latter := 1).

% The onset has to be no more than ACTIVE_TIME_BEFORE before the baseline
% training signal, and the 

% A positive that happens within ACTIVE_TIME of the event does not count as a
% false positive.  This is in seconds, and allows for some jitter.
ACTIVE_TIME_BEFORE = 0.01;
ACTIVE_TIME_AFTER = 0.01;
ACTIVE_TIMESTEPS_BEFORE = floor(ACTIVE_TIME_BEFORE / timestep_length);
ACTIVE_TIMESTEPS_AFTER = floor(ACTIVE_TIME_AFTER / timestep_length);

% The timesteps of interest are with reference to the start of the song.
% Responses have been trimmed to start at the start of recognition given
% the time window.  So we need to align those:

tstep_of_interest_shifted = tstep_of_interest_ds - time_window_ds + 1;

for i = 1:length(tstep_of_interest_ds)
        responses = squeeze(testout(i, :, :))';
        positive_interval = tstep_of_interest_shifted(i)-ACTIVE_TIMESTEPS_BEFORE:...
                tstep_of_interest_shifted(i)+ACTIVE_TIMESTEPS_AFTER;

        f = @(threshold)trigger_threshold_cost(threshold, ...
                responses, ...
                positive_interval, ...
                FALSE_POSITIVE_COST);
        
        % Find optimal threshold on the interval [0.001 1]
        % optimal_thresholds = fminbnd(f, 0.001, 1);
        %% Actually, fminbnd is useless at jumping out of local minima, and it's quick enough to brute-force it.
        ntestpts = 1000;
        best = Inf;
        testpts = linspace(0, 1, ntestpts);
        for j = 1:ntestpts
                outval = f(testpts(j));
                if outval < best
                        best = outval;
                        bestparam = testpts(j);
                end
        end
        optimal_thresholds(i) = bestparam;
end
