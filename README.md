#### Installation:

Make a local clone of this repository, with something like `git clone https://github.com/gardner-lab/syllable-detector-learn`.  Put the resulting directory in your MATLAB path.

Install the following third-party packages from the MATLAB File Exchange, and make sure they're in your MATLAB path:
* [_Significant Figures_ by Teck Por Lam.  File ID #10669](https://www.mathworks.com/matlabcentral/fileexchange/10669-significant-figures)
* [_Generate maximally perceptually-distinct colors_ by Tim Holy.  File ID #29702](https://www.mathworks.com/matlabcentral/fileexchange/29702-generate-maximally-perceptually-distinct-colors)

#### Running:

The entry point is `learn_detector.m`.  At the top thereof are a bunch of configuration parameters.  You can probably leave those untouched, but you should read through them to know what's available.  If you do want to touch them, do so by modifying `params.m`, below.

When `learn_detector` is run, it performs all operations in the current directory (use MATLAB's `cd` command to change, `pwd` to check; or the GUI).  It will look for a file called `song.mat`:

`song.mat` is a MATLAB savefile containing these three variables:
  * `song`: an MxN array of doubles, with M samples per song and N songs, all temporally aligned
  * `nonsong`: an MxP array of doubles, with M samples per song (same M as above) and P segments of non-song (silence, cage noise, white noise, etc).  Alignment here is irrelevant.
  * `fs`: the sampling frequency in Hz

Run `learn_detector`.  It will open `./song.mat`.  If you have not completed the next step (below), it should think for a while, pop up an aggregate spectrogram of all your aligned songs, and then stop (with a harmless error message), telling you to complete the next step:

Create a MATLAB script file (`params.m`, also in the current directory, containing configuration and training parameters:
  * If it doesn't exist, or is empty, `learn_detector` will pop up the spectrograms and then stop.
    * Add the line "times_of_interest_ms = [x y z ...]" for trigger times at x, y, and z (etc) milliseconds.  You need at least one time _x_.
  * `params.m` can also override any of the other parameters whose defaults are in the Configuration section at the top of `learn_detector.m`.

Run `learn_detector` again.  It will produce two files:
* `detector_<times_of_interest>_<other information>.mat`, the network file.
* `songs_<nsongs>_<times_of_interest_1>.wav`, an audio test file containing all the provided songs in the left channel and short pulses on the right channel at `times_of_interest(1)` for each provided song.  This may be used for testing the realtime detector.
