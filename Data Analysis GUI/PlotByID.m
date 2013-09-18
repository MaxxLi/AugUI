function PlotByID(IDVal, IDStr, ContVal, ContStr, handles)
axes(handles.axes1);
cla;

if IDVal > 1
    ID = str2double(IDStr(IDVal,:));
    mask1 = handles.allID == ID;
else
    mask1 = handles.allID > 0;
end

phandles =[];
if ContVal <= 10
    mask2 = (handles.allPPM(:,index) > 0 );
    concentrations = unique(handles.allPPM(:, ContVal));
    colors ='bgrkcmy'; 
    concentrations = concentrations(find(concentrations));

    for i=1:length(concentrations)
        if index<=10
            mask3 = handles.allPPM(:, ContVal) == concentrations(i) ;
        else
            mask3 = sum(aPPM)==0;
        end
        mask = mask1 & mask2 & mask3;
        h = plot(wavelengths,handles.allAbs(mask,:),colors(mod(i-1,7)+1));
        hold on; 
        phandles = [phandles, h(1)];


    end
    hold off;    
    units = {' ppm',' ppm',' ppm',' ppb',' ppm',' ppm',' ppb',' ppb',' ppb',' ppb'};
    text = num2str(concentrations(:));
    text = [text, repmat(units{index},length(concentrations),1)];
else
    mask2 = sum(handles.allPPM,2) == 0;
    groupID = unique(handles.allID(mask2));
    colors ='bgrkcmy'; 
    phandles =[];
    for i=1:length(groupID)
        mask3 = handles.allID == groupID(i) ;
        mask = mask1 & mask2 & mask3;
        h = plot(wavelengths,handles.allAbs(mask,:),colors(mod(i-1,7)+1));
        hold on; 
        phandles = [phandles, h(1)];
    end
    hold off;
    grid minor;
    text = num2str(groupID(:));
    legend(phandles, text);
    
end

grid minor;
axis([200 900 0 1]);axis('auto y');
contaminants = {'Nitrate','Nitrite','Copper','Iron','Glycol',...
        'Cyanide', 'Mercury','Acrylamide','24D','Chromate','Tap'};
title([contaminants{ContVal},' Training Data']);
xlabel('Wavelength(nm)');
ylabel('Absorption');
legend(phandles, text);

