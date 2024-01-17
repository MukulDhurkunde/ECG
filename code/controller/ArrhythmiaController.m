classdef ArrhythmiaController < Component

    properties (Access = private)
        RadioBtn1(1, 1) matlab.ui.control.RadioButton
        RadioBtn2(1, 1) matlab.ui.control.RadioButton
        RadioGroup matlab.ui.container.ButtonGroup
    end

    methods

        function obj = ArrhythmiaController(model, namedArgs)

            arguments
                model Model
                namedArgs.?ArrhythmiaController
            end

            obj@Component(model)
            set(obj, namedArgs)

        end

    end

    methods (Access = protected)

        function setup(obj)
            g = uigridlayout( ...
                'Parent', obj, ...
                'RowHeight', { "fit", "fit" }, ...
                'ColumnWidth', "1x", ...
                'Padding', [20, 4, 16, 8], ...
                'BackgroundColor', [0.8, 0.8, 0.8]);

            uilabel(g, 'Text', 'Arrhythmia', 'FontSize', 14, 'FontWeight', 'Bold');

            radioLayout = uigridlayout( ...
                'Parent', g, ...
                'RowHeight', 80, ...
                'ColumnWidth', "1x", ...
                'Padding', 0, ...
                'BackgroundColor', [0.8, 0.8, 0.8]);

            % Create button group for radio buttons
            obj.RadioGroup = uibuttongroup(radioLayout, 'BorderType', 'none', ...
                "SelectionChangedFcn", @obj.onSelectionChanged, 'BackgroundColor', [1, 1, 1]);

            % Create radio buttons.
            obj.RadioBtn1 = uiradiobutton(obj.RadioGroup, 'Text', 'Exclude', "Position",[10 100 100 22]);
            obj.RadioBtn2 = uiradiobutton(obj.RadioGroup, 'Text', 'Include', "Position",[10 70 100 22]);

        end

        function update(~)

        end

    end

    methods (Access = private)

        function onSelectionChanged(obj, ~, event)
            selectedButton = event.NewValue;
            if selectedButton == obj.RadioBtn1
                obj.Model.Values.arrhythmia = false;
            elseif selectedButton == obj.RadioBtn2
                obj.Model.Values.arrhythmia = true;
            end
        end

    end

end


