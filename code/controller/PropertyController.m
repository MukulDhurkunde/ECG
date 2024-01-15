classdef PropertyController < Component

    properties (Access = private)
        % Define input fields as properties for easy access.
        HeartRateField matlab.ui.control.NumericEditField
        PWaveField matlab.ui.control.NumericEditField
        QWaveField matlab.ui.control.NumericEditField
        QRSField matlab.ui.control.NumericEditField
        SWaveField matlab.ui.control.NumericEditField
        TWaveField matlab.ui.control.NumericEditField
        UWaveField matlab.ui.control.NumericEditField
        DPWaveField matlab.ui.control.NumericEditField
        DQWaveField matlab.ui.control.NumericEditField
        DQRSField matlab.ui.control.NumericEditField
        DSWaveField matlab.ui.control.NumericEditField
        DTWaveField matlab.ui.control.NumericEditField
        DUWaveField matlab.ui.control.NumericEditField
    end

    methods

        function obj = PropertyController(model, namedArgs)

            arguments
                model Model
                namedArgs.?PropertyController
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
                'Padding', 0);

            % Create and configure labels and input fields.
            obj.addLabeledNumericField(g, 'Heart Rate:', 72, 'HeartRateField');
            obj.addLabeledNumericField(g, 'P Wave:', 0.25, 'PWaveField');
            obj.addLabeledNumericField(g, 'Q Wave:', 0.025, 'QWaveField');
            obj.addLabeledNumericField(g, 'QRS Wave:', 1.4, 'QRSField');
            obj.addLabeledNumericField(g, 'S Wave:', 0.25, 'SWaveField');
            obj.addLabeledNumericField(g, 'T Wave:', 0.35, 'TWaveField');
            obj.addLabeledNumericField(g, 'U Wave:', 0.035, 'UWaveField');
            obj.addLabeledNumericField(g, 'P Wave:', 0.09, 'DPWaveField');
            obj.addLabeledNumericField(g, 'Q Wave:', 0.066, 'DQWaveField');
            obj.addLabeledNumericField(g, 'QRS Wave:', 0.11, 'DQRSField');
            obj.addLabeledNumericField(g, 'S Wave:', 0.066, 'DSWaveField');
            obj.addLabeledNumericField(g, 'T Wave:', 0.142, 'DTWaveField');
            obj.addLabeledNumericField(g, 'U Wave:', 0.0476, 'DUWaveField');
            
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

            values.heartRate = obj.HeartRateField.Value;
            values.aPwave = obj.PWaveField.Value;
            values.aQwave = obj.QWaveField.Value;
            values.aQRS = obj.QRSField.Value;
            values.aSwave = obj.SWaveField.Value;
            values.aTwave = obj.TWaveField.Value;
            values.aUwave = obj.UWaveField.Value;
            values.dPwave = obj.DPWaveField.Value;
            values.dQwave = obj.DQWaveField.Value;
            values.dQRS = obj.DQRSField.Value;
            values.dSwave = obj.DSWaveField.Value;
            values.dTwave = obj.DTWaveField.Value;
            values.dUwave = obj.DUWaveField.Value;

            % Invoke the random() method of the model.
            generateCustomECG(obj.Model, values)

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
