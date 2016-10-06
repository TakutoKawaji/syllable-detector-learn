### The entry point is `learn_detector.m`

At the top of that file are a bunch of configuration parameters.  You can probably leave those untouched, but you should read through them to know what's available.  If you do want to touch them, do so by modifying `params.m`, below.

Edit `learn_detector.m` as follows:
* Make sure `data_base_dir` points to your top-level data directory, which is expected to contain directories for birds by name (e.g. `lny44`)..  By default, `data_base_dir = /Volumes/Data/song`.
* Edit the "name of the bird" (the subdirectory of `/Volumes/Data/song`, e.g. `lny44`) to point to your bird's directory.

`/Volumes/Data/song/lny44` must contain the MATLAB data file `song.mat`, which defines the following variables:
  * `song`: an MxN array of doubles, with M samples per song and N songs, all temporally aligned
  * `nonsong`: an MxP array of doubles, with M samples per song (same M as above) and P segments of non-song (silence, cage noise, white noise, etc).  Alignment here is irrelevant.
  * `fs`: the sampling frequency in Hz

Run `learn_detector`.  If you have not completed the next step (below), it should think for a while, pop up an aggregate spectrogram of all your aligned songs, and then stop, telling you to complete the next step:

Create a MATLAB script file (`params.m`, also in the directory `<data_base_dir>/<bird>`), containing configuration and training parameters:
  * If it doesn't exist, or is empty, `learn_detector` will pop up the spectrograms and then stop (with a harmless error).
    * Add the line "times_of_interest = [x y z ...]" for trigger times at x, y, and z (etc) seconds.  At least one time of interest is required.  I like `times_of_interest = [ x y z] / 1e3`, so you can enter milliseconds.
  * It can contain overrides for all of the other parameters whose defaults are in the Configuration section at the top of learn_detector.m

Run `learn_detector` again.
