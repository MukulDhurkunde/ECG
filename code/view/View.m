classdef View < Component
    properties (Access = private)
        Line(1, 1) matlab.graphics.primitive.Line
        Listener(:, 1) event.listener {mustBeScalarOrEmpty}
    end

    methods
        function obj = View(model, namedArgs)
            arguments
                model(1, 1) Model
                namedArgs.?View
            end

            obj@Component(model)
            obj.Listener = listener(obj.Model, 'DataChanged', @obj.onDataChanged);
            set(obj, namedArgs);
            onDataChanged(obj);
        end
    end

    methods (Access = protected)
        function setup(obj)
            ax = axes('Parent', obj);
            obj.Line = line(ax, 'XData', [], 'YData', [], ...
                'Color', ax.ColorOrder(1, :), 'LineWidth', 1.5);
        end

        function update(~)
        end
    end

    methods (Access = private)
        function onDataChanged(obj, ~, ~)
            data = obj.Model.Data;
            updateGraph(obj, data);
        end

        function updateGraph(obj, data)
            ax = obj.Line.Parent;
            visibleIntervals = 300;  % Adjust this as needed

            % Calculate the start indices based on the current x-axis limits
            currentIndex = round(ax.XLim(1));

            % Update the x and y data
            set(obj.Line, 'XData', 1:numel(data), 'YData', data);

            % Set the Y-axis limits to the range of data
            set(ax, 'YLimMode', 'auto');

            % Adjust the x-axis limits for scrolling effect
            newLimits = [currentIndex, currentIndex + visibleIntervals - 1];
            set(ax, 'XLim', newLimits);
        end
    end
end
