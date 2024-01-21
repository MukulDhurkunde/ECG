function [finalEcg, locs] = detectPeak(ecgData)
    [finalEcg, locs] = findpeaks(ecgData, ...
        'MinPeakHeight', 0.5, 'MinPeakDistance',25);
end

