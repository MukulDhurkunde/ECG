classdef SimulationController < Component

    properties (Access = private)
        RadioBtn1(1, 1) matlab.ui.control.RadioButton
        RadioBtn2(1, 1) matlab.ui.control.RadioButton
        RadioGroup matlab.ui.container.ButtonGroup
    end

    methods

        function obj = SimulationController(model, namedArgs)

            arguments
                model Model
                namedArgs.?SimulationController
            end

            obj@Component(model)
            set(obj, namedArgs)

        end

    end

    methods (Access = protected)

        function setup(obj)
            g = uigridlayout( ...
                'Parent', obj, ...
                'RowHeight', { "fit" }, ...
                'ColumnWidth', "1x", ...
                'Padding', [20, 4, 16, 8], ...
                'BackgroundColor', [0.8, 0.8, 0.8]);

            % Create button.
            uibutton( ...
                'Parent', g, ...
                'Text', 'Generate ECG', 'BackgroundColor', [0, 0, 0], ...
                'FontColor', [1, 1, 1], 'FontSize', 14, 'FontWeight', 'Bold', ...
                'ButtonPushedFcn', @obj.onButtonPushed);
        end

        function update(~)

        end

    end

    methods (Access = private)

        function onButtonPushed(obj, ~, ~)
            generateCustomECG(obj.Model)
        end

    end

end
