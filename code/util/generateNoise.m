function [finalEcg] = generateNoise(ecgData)
     noiseAmplitude = 0.2; % Increase the noise amplitude1
     noise = noiseAmplitude * randn(size(ecgData));
    
     % Add noise to the ECG-like signal
     noisyEcg = ecgData + noise;
    
     % Apply a moving average filter to remove 
     filteredEcg = movmean(noisyEcg, 5);
     finalEcg = filteredEcg;
end
