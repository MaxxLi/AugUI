%Sample rate in Hz
sampleRate = 10000;
%Number of samples
sampleNum = 30000;

%DAQ hardware address
daqAddress = 'Dev4';

%DAQ initialization
ai = analoginput('nidaq', daqAddress);
ai.SampleRate = sampleRate;
ai.SamplesPerTrigger = sampleNum;

addchannel(ai, 0);

start(ai);

[d,t] = getdata(ai);

V = mean(d);