function [ecgData, locs] = generateECG(heartRate, aPwav, dPwav, aQwav, dQwav, ...
    aQrswav, dQrswav, aSwav, dSwav, aTwav, dTwav, aUwav, dUwav, noise, detectPeak)

    x = 0.01:0.01:600;
    li = 30/heartRate;  
    
    tPwav = 0.16;  
    tQwav = 0.166;
    tSwav = 0.09;
    tTwav = 0.2;
    tUwav = 0.433;

    % Calculate individual waves
    pwav = pWav(x, aPwav, dPwav, tPwav, li);
    qwav = qWav(x, aQwav, dQwav, tQwav, li);
    qrswav = qrsWav(x, aQrswav, dQrswav, li);
    swav = sWav(x, aSwav, dSwav, tSwav, li);
    twav = tWav(x, aTwav, dTwav, tTwav, li);
    uwav = uWav(x, aUwav, dUwav, tUwav, li);

    % Generate ECG signals without randomness
    ecgData = pwav + qwav + qrswav + swav + twav + uwav;

    % Introduce randomness (5% probability of faster or slower heartbeats)
    for i = 1:numel(x)
        if rand() < 0.05  % 5% probability
            % Adjust the heart rate randomly (you can modify this part)
            factor = 1 + randn() * 0.05;  % Random factor with mean 1 and standard deviation 0.05
            ecgData(i) = ecgData(i) * factor;
        end
    end

    if (noise)
        ecgData = generateNoise(ecgData);
    end

    locs = [];
    if (detectPeak)
        [ecgData, locs] = detectPeak(ecgData);
    end
end

function [pwav] = pWav(x, aPwav, dPwav, tPwav, li)
    l = li;
    a = aPwav;
    x = x + tPwav;
    b = (2 * l) / dPwav;
    n = 100;
    p1 = 1 / l;
    p2 = 0;
    for i = 1:n
        harm1 = (((sin((pi / (2 * b)) * (b - (2 * i)))) / (b - (2 * i)) + (sin((pi / (2 * b)) * (b + (2 * i)))) / (b + (2 * i))) * (2 / pi)) * cos((i * pi * x) / l);
        p2 = p2 + harm1;
    end
    pwav1 = p1 + p2;
    pwav = a * pwav1;
end

function [qrswav] = qrsWav(x, aQrswav, dQrswav, li)
    l = li;
    a = aQrswav;
    b = (2 * l) / dQrswav;
    n = 100;
    qrs1 = (a / (2 * b)) * (2 - b);
    qrs2 = 0;
    for i = 1:n
        harm = (((2 * b * a) / (i * i * pi * pi)) * (1 - cos((i * pi) / b))) * cos((i * pi * x) / l);
        qrs2 = qrs2 + harm;
    end
    qrswav = qrs1 + qrs2;
end

function [qwav] = qWav(x, aQwav, dQwav, tQwav, li)
    l = li;
    x = x + tQwav;
    a = aQwav;
    b = (2 * l) / dQwav;
    n = 100;
    q1 = (a / (2 * b)) * (2 - b);
    q2 = 0;
    for i = 1:n
        harm5 = (((2 * b * a) / (i * i * pi * pi)) * (1 - cos((i * pi) / b))) * cos((i * pi * x) / l);
        q2 = q2 + harm5;
    end
    qwav = -1 * (q1 + q2);
end

function [swav] = sWav(x, aSwav, dSwav, tSwav, li)
    l = li;
    x = x - tSwav;
    a = aSwav;
    b = (2 * l) / dSwav;
    n = 100;
    s1 = (a / (2 * b)) * (2 - b);
    s2 = 0;
    for i = 1:n
        harm3 = (((2 * b * a) / (i * i * pi * pi)) * (1 - cos((i * pi) / b))) * cos((i * pi * x) / l);
        s2 = s2 + harm3;
    end
    swav = -1 * (s1 + s2);
end

function [twav] = tWav(x, aTwav, dTwav, tTwav, li)
    l = li;
    a = aTwav;
    x = x - tTwav - 0.045;
    b = (2 * l) / dTwav;
    n = 100;
    t1 = 1 / l;
    t2 = 0;
    for i = 1:n
        harm2 = (((sin((pi / (2 * b)) * (b - (2 * i)))) / (b - (2 * i)) + (sin((pi / (2 * b)) * (b + (2 * i)))) / (b + (2 * i))) * (2 / pi)) * cos((i * pi * x) / l);
        t2 = t2 + harm2;
    end
    twav1 = t1 + t2;
    twav = a * twav1;
end

function [uwav] = uWav(x, aUwav, dUwav, tUwav, li)
    l = li;
    a = aUwav;
    x = x - tUwav;
    b = (2 * l) / dUwav;
    n = 100;
    u1 = 1 / l;
    u2 = 0;
    for i = 1:n
        harm4 = (((sin((pi / (2 * b)) * (b - (2 * i)))) / (b - (2 * i)) + (sin((pi / (2 * b)) * (b + (2 * i)))) / (b + (2 * i))) * (2 / pi)) * cos((i * pi * x) / l);
        u2 = u2 + harm4;
    end
    uwav1 = u1 + u2;
    uwav = a * uwav1;
end