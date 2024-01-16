classdef View < Component
    properties (Access = private)
        Line(1, 1) matlab.graphics.primitive.Line
        Listener(:, 1) event.listener {mustBeScalarOrEmpty}
        ResetListener(:, 1) event.listener {mustBeScalarOrEmpty}
        ScrollTimer timer
    end

    methods
        function obj = View(model, namedArgs)
            arguments
                model(1, 1) Model
                namedArgs.?View
            end

            obj@Component(model)
            obj.Listener = listener(obj.Model, 'DataChanged', @obj.onDataChanged);
            obj.ResetListener = listener(obj.Model, 'Reset', @obj.onResetData);
            set(obj, namedArgs);
            onDataChanged(obj);
        end

        function delete(obj)
            % Cleanup method to stop and delete the timer when the instance is deleted
            if ~isempty(obj.ScrollTimer) && isvalid(obj.ScrollTimer)
                stop(obj.ScrollTimer);
                delete(obj.ScrollTimer);
            end
        end
    end

    methods (Access = protected)
        function setup(obj)
            ax = axes('Parent', obj);
            grid(ax, 'on');

            % Label the axes
            xlabel(ax, 'Time (centisecond)');
            ylabel(ax, 'Voltage (millivolt)');

            obj.Line = line(ax, 'XData', [], 'YData', [], ...
                'Color', ax.ColorOrder(1, :), 'LineWidth', 1.5);
        end

        function update(~)
        end
    end

    methods (Access = private)
        function onDataChanged(obj, ~, ~)
            onResetData(obj);

            % Set up new timer for scrolling
            obj.ScrollTimer = timer(...
                'ExecutionMode', 'fixedRate', ...
                'Period', 1, ...  % Set the scrolling period in seconds
                'TimerFcn', @(~,~) obj.scrollAxes);
            start(obj.ScrollTimer);
        end

        function onResetData(obj, ~, ~)
            data = obj.Model.Data;
            updateGraph(obj, data);

            % Stop and delete the timer
            if ~isempty(obj.ScrollTimer) && isvalid(obj.ScrollTimer)
                stop(obj.ScrollTimer);
                delete(obj.ScrollTimer);
            end

            set(obj.Line.Parent, 'XLim', [0, 400]);
        end

        function updateGraph(obj, data)
            ax = obj.Line.Parent;
            visibleIntervals = 400;  % Adjust this as needed

            % Calculate the start indices based on the current x-axis limits
            currentIndex = round(ax.XLim(1));

            % Update the x and y data
            set(obj.Line, 'XData', 400:numel(data) + 399, 'YData', data);

            % Set the Y-axis limits to the range of data
            set(ax, 'YLimMode', 'auto');

            % Adjust the x-axis limits for scrolling effect
            newLimits = [currentIndex, currentIndex + visibleIntervals - 1];
            set(ax, 'XLim', newLimits);
        end

        function scrollAxes(obj)
            ax = obj.Line.Parent;
            
            % Calculate the new start index based on the current x-axis limits
            currentLimits = ax.XLim;
            newStartIndex = round(currentLimits(1)) + 100;
            
            % Update the x-axis limits for jumping effect
            newLimits = [newStartIndex, newStartIndex + (currentLimits(2) - currentLimits(1))];
            set(ax, 'XLim', newLimits);
        end

    end
end
