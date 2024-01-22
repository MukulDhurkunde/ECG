function [ecg] = generateNoise(ecgData)
    % Parameters
    noiseAmplitude = 0.2;
    spikeProbability = 0.01;
    spikeAmplitude = 2;

    % Generate Gaussian noise
    gaussianNoise = noiseAmplitude * randn(size(ecgData));

    % Generate random spikes
    spikeNoise = zeros(size(ecgData));
    spikes = rand(size(ecgData)) < spikeProbability;
    spikeNoise(spikes) = spikeAmplitude;

    % Combine noise components
    totalNoise = gaussianNoise + spikeNoise;

    % Add noise to the ECG-like signal
    noisyEcg = ecgData + totalNoise;

    % Apply a moving average filter to smooth the signal
    windowSize = 5;
    smoothedEcg = movmean(noisyEcg, windowSize);

    % Apply a low-pass filter to further reduce noise
    cutoffFrequency = 5;  % Adjust this as needed
    lowpassFilteredEcg = lowpass(smoothedEcg, cutoffFrequency, 1000);  % 1000 Hz sampling rate assumed

    % Combine filtered signal with a fraction of the original noise
    filteredWithNoise = 0.8 * lowpassFilteredEcg + 0.1 * noisyEcg;

    ecg = filteredWithNoise;
end
