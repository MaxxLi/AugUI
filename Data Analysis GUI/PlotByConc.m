function PlotByConc(ConcVal, ConcStr, ContVal, ContStr, handles)

axes(handles.axes1);
cla;

if ContVal <= 10
	load signaturesM.mat
	conc = str2double(ConcStr(ConcVal,:));
	mask1 = handles.allPPM(:,ContVal) == conc;
	%plot(wavelengths, handles.allAbs(mask,:),'red');
	mask2 = (handles.allPPM(:,ContVal) > 0 );
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
	axis([200 900 0 1]);axis('auto y');
	contaminants = {'Nitrate','Nitrite','Copper','Iron','Glycol',...
		'Cyanide', 'Mercury','Acrylamide','24D','Chromate'};
	title([contaminants{ContVal},' Training Data']);
	xlabel('Wavelength(nm)');
	ylabel('Absorption');
	text = num2str(groupID(:));
	legend(phandles, text);
else 
	msgbox('Tap Water does not require concentration');
	
end
