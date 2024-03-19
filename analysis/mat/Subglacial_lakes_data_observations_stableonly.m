% Plotting the most recent global inventory of STABLE ONLY subglaical lakes
% from Livingston et al 2022
%
% REQUIREMENTS
% Mapping Toolbox
% Climate Data Toolbox
% Antarctic Mapping Toolbox
% Antarctic boundaries, grounding line, and masks from InSAR

%% KEY
% RES only = 1 = red 
% RES and flat ice surface 2 = yellow
% Seismic = 3 = black
% Drilled = blue
% active lake = 0 = not plotted

addpath(genpath('/home/user1/MATLAB/AntarcticMappingTools'));
addpath(genpath('/home/user1/MATLAB/Antarctic-boundaries'));

close all
clear all

load('../../data/generated/mat/global_lakes_stableonly.mat')

%% GREENLAND
r = 5; % radius of circles

figure
bordersm('greenland')
hold on
for i = 1:length(Green_lakes)
    if Green_lakes(i,4) == 3 % SEISMIC
       plotm(Green_lakes(i,2),Green_lakes(i,3),'o','Markersize',r,'MarkerEdgeColor','k','LineWidth',0.5,'MarkerFaceColor','k')
    elseif Green_lakes(i,4) == 2 % RES and flat ice surface
       plotm(Green_lakes(i,2),Green_lakes(i,3),'o','Markersize',r,'MarkerEdgeColor','k','LineWidth',0.5,'MarkerFaceColor','y')
    elseif Green_lakes(i,4) == 1 % RES ONLY
       plotm(Green_lakes(i,2),Green_lakes(i,3),'o','Markersize',r,'MarkerEdgeColor','k','LineWidth',0.5,'MarkerFaceColor','r')
    end
end

%% Antarctic
r = 35; % radius of circles

figure
antbounds('gl','color',[0 0.4470 0.7410])
hold on
antbounds('coast','color',[0 0.4470 0.7410]) 
graticuleps(-90:10:-60,-180:30:180,'color',[0.6 0.6 0.6],'LineWidth',0.1,'LineStyle',":")
hold on
for i = 1:length(Ant_lakes)
    if Ant_lakes(i,4) == 3 % seismic
        circleps(Ant_lakes(i,2),Ant_lakes(i,3),r, 'facecolor', 'k') 
    elseif Ant_lakes(i,4) == 2 % res and flat ice surface
       circleps(Ant_lakes(i,2),Ant_lakes(i,3),r, 'facecolor', 'y') 
   elseif Ant_lakes(i,4) == 1 % RES only
       circleps(Ant_lakes(i,2),Ant_lakes(i,3),r, 'facecolor', 'r') 
    end
end
% seimsic lakes to be plotted on top
hold on
circleps(Ant_lakes(63,2),Ant_lakes(63,3),r, 'facecolor', 'k')
hold on
circleps(Ant_lakes(70,2),Ant_lakes(70,3),r, 'facecolor', 'k')
hold on
circleps(Ant_lakes(616,2),Ant_lakes(616,3),r, 'facecolor', 'k')

% Lake Vostok
hold on
circleps(Ant_lakes(2,2),Ant_lakes(2,3),r, 'facecolor', 'b')
% SLW
hold on
circleps(Ant_lakes(236,2),Ant_lakes(236,3),r, 'facecolor', 'b')
% SLM
hold on
circleps(Ant_lakes(202,2),Ant_lakes(202,3),r, 'facecolor', 'b')
set(gca,'XTick',[], 'YTick', [])
