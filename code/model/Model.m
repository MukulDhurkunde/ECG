classdef Model < handle
    %MODEL Application data model.
    
    properties ( SetAccess = private )
        % Application data.
        Data(:, 1) double = double.empty(0, 1)
    end % properties ( SetAccess = private )
    
    events ( NotifyAccess = private )
        % Event broadcast when the data is changed.
        DataChanged
    end % events ( NotifyAccess = private )
    
    methods

        function random( obj )
            %RANDOM Generate new application data.
            
            % Generate column vector of random data.
            obj.Data = randn( 20, 1 );
            notify( obj, "DataChanged" )
            
        end % random

        function generateCustomECG( obj )
            heartRate = 75;  % Adjust the heart rate as needed
            pulseRate = 80;  % Adjust the pulse rate as needed
            pWave = 0.1;    % Adjust the P-wave duration as needed
            qrs = 0.08;     % Adjust the QRS duration as needed
            tWave = 0.2;    % Adjust the T-wave duration as needed
            duration = 60;   % Duration in seconds
            samplingRate = 1000;

            ecgData = generateECG();
            obj.Data = ecgData;
            notify( obj, "DataChanged" )
        end
        
        function reset( obj )
            %RESET Restore the application data to its default value.
            
            % Reset the data to an empty column vector.
            obj.Data = double.empty( 0, 1 );
            notify( obj, "DataChanged" )
            
        end % reset
        
    end % methods
    
end % classdef