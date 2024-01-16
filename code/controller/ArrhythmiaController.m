

classdef ArrhythmiaController < Component

    properties (Access = private)
        % Define input fields as properties for easy access.
        HeartRateField matlab.ui.control.NumericEditField
    end

    methods

        function obj = ArrhythmiaController(model, namedArgs)

            arguments
                model Model
                namedArgs.?ArrhythmiaController
            end % arguments

            % Call the superclass constructor.
            obj@Component(model)

            % Set any user-specified properties.
            set(obj, namedArgs)

        end % constructor

    end % methods

    methods (Access = protected)

        function setup(obj)
            % SETUP Initialize the controller.

            % Create grid layout.
            g = uigridlayout( ...
                'Parent', obj, ...
                'RowHeight', "1x", ...
                'ColumnWidth', "1x", ...
                'Padding', 10);

            % Create and configure labels and input fields.
            obj.addLabeledNumericField(g, 'Heart Rate:', 70, 'HeartRateField');

            % Create button.
            uibutton( ...
                'Parent', g, ...
                'Text', 'Generate ECG', ...
                'ButtonPushedFcn', @obj.onButtonPushed);

        end % setup

        function update(~)
            % UPDATE Update the controller. This method is empty because
            % there are no public properties of the controller.

        end % update

    end % methods (Access = protected)

    methods (Access = private)

        function onButtonPushed(obj, ~, ~)

            % Invoke the random() method of the model.
            random(obj.Model)

        end % onButtonPushed

        function addLabeledNumericField(obj, parent, labelText, defaultValue, fieldName)
            % Helper function to add a labeled numeric field.

            container = uigridlayout(parent, 'RowHeight', "1x", 'ColumnWidth', {"1x", "3x"}, 'Padding', 5);

            uilabel(container, 'Text', labelText, 'HorizontalAlignment', 'Right');
            obj.(fieldName) = uieditfield(container, 'numeric', 'Value', defaultValue, 'Limits', [0, Inf], 'ValueChangedFcn', @(src, event) obj.validateInput(src, labelText));
        end

        function validateInput(~, src, fieldName)
            % Validate the input to ensure it is numeric.

            input = src.Value;

            if ~isnumeric(input) || ~isscalar(input)
                % Display an error message for invalid input.
                msg = sprintf('Invalid input value for %s. Please enter a numeric value.', fieldName);
                errordlg(msg, 'Invalid Input', 'modal');

                % Reset the input field to its previous value.
                src.Value = src.Value;
            end

        end % validateInput

    end % methods (Access = private)

end % classdef