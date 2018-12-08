%% Attentional Scanner Experiment Replication
% Dependenies: MATLAB 2017b or higher (Mac)
% Version history: V2 - 03/03/2018

% Note: Running 1280 trials takes time. If you don't want to take about 20
% minutes to run it, you can change the code in Line75 (for n = 1:80) to a
% smaller number such as n = 1:5 so get a rough idea. I also uploaded a
% sample data file, you can use that data to directly plot the bar graph (but
% there's no significant difference)
%% Initialization
clear all
close all
clc

% parameters
Fs = 40;  %font size for welcome text and thank you text
fS = 20;  %font size for instructions
fN = 'Arial';
startaxis = 0;
endaxis = 100;
startPlot = 30;  %to locate the rectangle at the center, the bottom left point:(30,30), top left: (30,60) 
endPlot = 60;    %the bottom right point needs to be at (60,30),the top right: (60,60) 
stepSize = 10;   
sideLength = 10; %the side length of each small square is 10
r_store = cell(1,16); %to store the 16 locations
pos = 0;  %initialize the position index
response = []; %to store the total responses
reaction = nan(16,3); %to store the responses for the current round

%% Presentation of stimuli
f1 = figure;
screensize = get(0,'ScreenSize');
set(gcf,'Position',screensize);
%display welcome screen
Welcometext = text(.5,.5,'Welcome!');
axis off
set(gcf,'color','w');
set(Welcometext,'HorizontalAlignment','center');
set(Welcometext,'color','k')
set(Welcometext,'FontSize',Fs);
set(Welcometext,'FontWeight','b');
shg
pause
delete(Welcometext)
%display instruction
message = sprintf('The cue will be displayed in red \n and the target will be displayed in blue.\n Press SPACE only after you see the target.\n Now press any key to proceed.');
Instructiontext = text(.5,.5,message);
axis off
set(gcf,'color','w');
set(Instructiontext,'HorizontalAlignment','center');
set(Instructiontext,'color','k')
set(Instructiontext,'FontSize',fS);
set(Instructiontext,'FontWeight','b');
shg
pause
delete(Instructiontext)
%create the spacial grid first
for i = startPlot:stepSize:endPlot
    for j = startPlot:stepSize:endPlot
        pos = pos+1;
        xlim([startaxis endaxis]);
        ylim([startaxis endaxis]);
        r = rectangle('position',[i j sideLength sideLength]);
        axis square
        axis equal
        axis off
        hold on
        set(gcf,'Color','w')
        r_store{pos} = r;
    end
end
%create the trials
index = 0; %used later for differentiation of valid and invalid trials 
for n = 1:80
    rand_pos = randperm(16);
    for m = 1:16
        index = index + 1;  %update current index
        pause(rand(1)*0.5); %randomly choose from 0~1s and transform it to 0~500ms (1s = 1000ms)
        shg %if the participant press the key before the target is present, the main screen of MATLAB will show up, so use 'shg' to go back to the figure 
        r_store{rand_pos(m)}.FaceColor = 'r'; %set the cue to be red, and it can be from any one of the 16 locations
        pause(0.2);
        shg 
        r_store{rand_pos(m)}.FaceColor = 'w'; %let the cue be invisible
        pause(rand(1)*0.5);
        shg
        if mod(index,5) == 0 %make sure invalid trials are equal to 20% of the total trials, because only one in five numbers will gives mod(index,5) = 0
            r_store{m}.FaceColor = 'b'; %the target appears at another location
            reaction(m,3) = 0; %indicates this is an invalid trial
        else r_store{rand_pos(m)}.FaceColor = 'b'; %the target appears at the same location as the cue
            reaction(m,3) = 1; %indicates this is a valid trial
        end
        tic
        disp('Please press space as soon as possible after you see the target')
        pause
        reaction(m,2) = toc; %record the reaction time
        reaction(m,1) = get(gcf,'CurrentCharacter'); %keep track of the input
        if mod(index,5) == 0 %make the target invisible
            r_store{m}.FaceColor = 'w';
        else r_store{rand_pos(m)}.FaceColor = 'w';
        end
        response = [response;reaction(m,:)]; %update the total responses
    end
end
clf %clear pictures
Thankyoutext = text(.5,.5,'Thank you!');
axis off
set(gcf,'color','w');
set(Thankyoutext,'HorizontalAlignment','center');
set(Thankyoutext,'color','k')
set(Thankyoutext,'FontSize',Fs);
set(Thankyoutext,'FontWeight','b');
pause(2) %the figure will pause for 2 seconds
close %and close automatically

%% Plot the figure
response(:,2) = response(:,2)*1000; %tranform reaction time from s to ms
meanRT_valid= mean(response((response(:,3)==1),2));
meanRT_invalid= mean(response((response(:,3)==0),2));
meanRT = [meanRT_valid meanRT_invalid];
nbars = 1:2;
RTbar = bar(nbars,meanRT);
xlabel('Type of Trials');
ylabel('Mean Reaction Time (ms)');
title('Reaction Time across Trials');
xticklabels({'Valid Trials' 'Invalid Trials'});
set(RTbar,'FaceColor', [0.85 0.85 0.85]);
set(gca, 'fontName', fN);
set(gca, 'fontAngle', 'italic');
set(gcf,'color','w');