function twostep(filelist_filename, crunchspec, epdir, outdir)
%% creates a rotation from a set of files and then applies it to all those files

%% filelist has  au filenames, but we look up the corresponding ep files, 
%%   assuming that they have already been created; if not, use multirespond.py
%%   as is done in pfrotate.py
%% Something a little error-prone is that the
%%   created normalization and rotation parameters are transmitted from 
%%   step one to step two via a temp file called rotationspec.mat

createnormrot(filelist_filename, crunchspec, epdir, outdir);

tic;
applynormrot(filelist_filename, crunchspec, epdir, outdir);
fprintf('Total time to apply the rotations ');
toc

