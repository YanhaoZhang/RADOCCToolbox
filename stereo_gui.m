% stereo_gui
% Stereo Camera Calibration Toolbox (two cameras, internal and external calibration):
%
% It is assumed that the two cameras (left and right) have been calibrated with the pattern at the same 3D locations, and the same points
% on the pattern (select the same grid points). Therefore, in particular, the same number of images were used to calibrate both cameras.
% The two calibration result files must have been saved under two seperate data files (Calib_Results_left.mat and Calib_Results_right.mat)
% prior to running this toolbox. To generate the two files, run the classic Camera Calibration toolbox calib.m.
%
% INPUT: Calib_Results_left.mat, Calib_Results_right.mat -> Generated by the standard calibration toolbox on the two cameras individually
% OUTPUT: Calib_Results_stereo.mat -> The saved result after global stereo calibration (after running stereo calibration, and hitting Save stereo calib results)
% 
% Main result variables stored in Calib_Results_stereo.mat:
% om, R, T: relative rotation and translation of the right camera wrt the left camera
% fc_left, cc_left, kc_left, alpha_c_left, KK_left: New intrinsic parameters of the left camera
% fc_right, cc_right, kc_right, alpha_c_right, KK_right: New intrinsic parameters of the right camera
% 
% Both sets of intrinsic parameters are equivalent to the classical {fc,cc,kc,alpha_c,KK} described online at:
% http://www.vision.caltech.edu/bouguetj/calib_doc/parameters.html
%
% Note: If you do not want to recompute the intinsic parameters, through stereo calibration you may want to set
% recompute_intrinsic_right and recompute_intrinsic_left to zero, prior to running stereo calibration. Default: 1
%
% Definition of the extrinsic parameters: R and om are related through the rodrigues formula (R=rodrigues(om)).
% Consider a point P of coordinates XL and XR in the left and right camera reference frames respectively.
% XL and XR are related to each other through the following rigid motion transformation:
% XR = R * XL + T
% R and T (or equivalently om and T) fully describe the relative displacement of the two cameras.
%
%
% If the Warning message "Disabling view kk - Reason: the left and right images are found inconsistent" is encountered during stereo calibration,
% that probably means that for the kkth pair of images, the left and right images are found to have captured the calibration pattern at two
% different locations in space. That means that the two views are not consistent, and therefore cannot be used for stereo calibration.
% When capturing your images, make sure that you do not move the calibration pattern between capturing the left and the right images.
% The pattwern can (and should) be moved in space only between two sets of (left,right) images.
% Another reason for inconsistency is that you selected a different set of points on the pattern when running the separate calibrations
% (leading to the two files Calib_Results_left.mat and Calib_Results_left.mat). Make sure that the same points are selected in the
% two separate calibration. In other words, the points need to correspond.

% (c) Jean-Yves Bouguet - Intel Corporation
% October 25, 2001 -- Last updated June 14, 2004

function stereo_gui,


cell_list = {};


%-------- Begin editable region -------------%
%-------- Begin editable region -------------%


fig_number = 1;

title_figure = 'Stereo Camera Calibration Toolbox';

cell_list{1,1} = {'Load left and right calibration files','load_stereo_calib_files2;'};
cell_list{1,2} = {'Run stereo calibration','calib_stereo_auto2;'};
cell_list{2,1} = {'Show Extrinsics of stereo rig','ext_calib_stereo;'};
cell_list{2,2} = {'Show Intrinsic parameters','show_stereo_calib_results;'};
cell_list{3,1} = {'Save stereo calib results','saving_stereo_calib;'};
cell_list{3,2} = {'Load stereo calib results','loading_stereo_calib;'};
cell_list{4,1} = {'Rectify the calibration images','rectify_stereo_pair;'};
cell_list{4,2} = {'Exit',['disp(''Bye. To run again, type stereo_gui.''); close(' num2str(fig_number) ');']}; %{'Exit','calib_gui;'};


show_window(cell_list,fig_number,title_figure,150,14);


%-------- End editable region -------------%
%-------- End editable region -------------%






%------- DO NOT EDIT ANYTHING BELOW THIS LINE -----------%

function show_window(cell_list,fig_number,title_figure,x_size,y_size,gap_x,font_name,font_size)


if ~exist('cell_list'),
    error('No description of the functions');
end;

if ~exist('fig_number'),
    fig_number = 1;
end;
if ~exist('title_figure'),
    title_figure = '';
end;
if ~exist('x_size'),
    x_size = 85;
end;
if ~exist('y_size'),
    y_size = 14;
end;
if ~exist('gap_x'),
    gap_x = 0;
end;
if ~exist('font_name'),
    font_name = 'clean';
end;
if ~exist('font_size'),
    font_size = 8;
end;

figure(fig_number); clf;
pos = get(fig_number,'Position');

[n_row,n_col] = size(cell_list);

fig_size_x = x_size*n_col+(n_col+1)*gap_x;
fig_size_y = y_size*n_row+(n_row+1)*gap_x;

set(fig_number,'Units','points', ...
	'BackingStore','off', ...
	'Color',[0.8 0.8 0.8], ...
	'MenuBar','none', ...
	'Resize','off', ...
	'Name',title_figure, ...
'Position',[pos(1) pos(2) fig_size_x fig_size_y], ...
'NumberTitle','off'); %,'WindowButtonMotionFcn',['figure(' num2str(fig_number) ');']);

h_mat = zeros(n_row,n_col);

posx = zeros(n_row,n_col);
posy = zeros(n_row,n_col);

for i=n_row:-1:1,
   for j = n_col:-1:1,
      posx(i,j) = gap_x+(j-1)*(x_size+gap_x);
      posy(i,j) = fig_size_y - i*(gap_x+y_size);
   end;
end;

for i=n_row:-1:1,
    for j = n_col:-1:1,
        if ~isempty(cell_list{i,j}),
            if ~isempty(cell_list{i,j}{1}) & ~isempty(cell_list{i,j}{2}),
                h_mat(i,j) = uicontrol('Parent',fig_number, ...
                    'Units','points', ...
                    'Callback',cell_list{i,j}{2}, ...
                    'ListboxTop',0, ...
                    'Position',[posx(i,j)  posy(i,j)  x_size   y_size], ...
                    'String',cell_list{i,j}{1}, ...
                    'fontsize',font_size,...
                    'fontname',font_name,...
                    'Tag','Pushbutton1');
            end;
        end;
    end;
end;

%------ END PROTECTED REGION ----------------%
