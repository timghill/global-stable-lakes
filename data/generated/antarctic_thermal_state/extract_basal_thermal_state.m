% Interpolate basal thermal state from ISSM model outputs to a
% regular rectangular mesh and save as a *.nc file

% File structure
ISSM_path = '/home/user1/SFU-code/ISSM-source/';
ISSM_output_dir = '../../raw/antarctic_basal_thermal_state/';
ISSM_output_files = {
    'Antarctica_Transient_Ctrl_100yrs.mat',...
    'Antarctica_Transient_Exp1_100yrs.mat',...
    'Antarctica_Transient_Exp2_100yrs.mat',...
    'Antarctica_Transient_Exp3_100yrs.mat',...
    'Antarctica_Transient_Exp4_100yrs.mat'};

% Add ISSM to path to read model outputs
addpath([ISSM_path, 'bin/'])
addpath([ISSM_path, 'lib/'])

% Parameters for regular rectangular mesh
dx = 5e3;
dy = 5e3;
xmin = -2510000;
xmax = 2745000;
ymin = -2145000;
ymax = 2245000;
xg = xmin:dx:xmax;
yg = ymin:dy:ymax;
[xxg, yyg] = meshgrid(xg, yg);
[ny, nx] = size(xxg);

% Save fields as nc file
nc_xy_fname = 'xy.nc';
if isfile(nc_xy_fname)
    delete(nc_xy_fname)
end
nccreate(nc_xy_fname, 'x', 'Dimensions', {'y', ny, 'x', nx});
ncwrite(nc_xy_fname, 'x', xxg);

nccreate(nc_xy_fname, 'y', 'Dimensions', {'y', ny, 'x', nx});
ncwrite(nc_xy_fname, 'y', yyg);

% Parameters for interpolation
interp_method = 'linear';
extrap_method = 'none';

% Loop over files and convert
for ii=1:length(ISSM_output_files)
    ISSM_output_path = [ISSM_output_dir, ISSM_output_files{ii}];
    nc_fname = replace(ISSM_output_files{ii}, '.mat', '.nc');
    if isfile(nc_fname)
        disp(['File ', nc_fname, ' already exists; skipping'])
        continue
    end
    
    disp(['Loading ISSM output ', ISSM_output_path])
    md_struct = load(ISSM_output_path);
    md = md_struct.md;
    clear md_struct
    
    T = md.results.ThermalSolution.Temperature;
    Tm = T + md.materials.beta.*md.initialization.pressure; % pressure adjusted temperature  

    x = md.mesh.x;
    y = md.mesh.y;
    z = md.mesh.z;
    vertexonbase = (md.mesh.vertexonbase==1);

    % MATLAB-based 2D interpolation
    Tm_interp_func = scatteredInterpolant(x(vertexonbase), ...
        y(vertexonbase), Tm(vertexonbase), interp_method, extrap_method);
    mask_interp_func = scatteredInterpolant(x(vertexonbase), ...
        y(vertexonbase), md.mask.ice_levelset(vertexonbase),...
        interp_method, extrap_method);
    
    % Interpolate the mask and pressure-adjusted basal temperature,
    % setting the basal temperature to nan outside the ice domain
    mask_rect = mask_interp_func(xxg, yyg);
    Tm_rect = Tm_interp_func(xxg, yyg);
    Tm_rect(mask_rect>=0) = nan;

    nccreate(nc_fname, 'Tm', 'Dimensions', {'y', ny, 'x', nx});
    ncwrite(nc_fname, 'Tm', Tm_rect)
end