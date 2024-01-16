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

            columnLayout = uigridlayout('Parent', obj, ...
                'RowHeight', {"fit", "fit"}, ...
                'ColumnWidth', "1x", ...
                'Padding', [20, 4, 16, 16], ...
                'BackgroundColor', [0.8, 0.8, 0.8]);

            uilabel(columnLayout, 'Text', 'Configure ECG Properties', 'FontSize', 14, 'FontWeight', 'Bold');

            % Create grid layout.
            g = uigridlayout( ...
                'Parent', columnLayout, ...
                'RowHeight', "1x", ...
                'ColumnWidth', {"fit", "1x", "1x"}, ...
                'Padding', 0, ...
                'BackgroundColor', [0.8, 0.8, 0.8]);

            uilabel(g, 'Text', 'Heart Rate :');
            obj.addLabeledNumericField(g, 'Heart Rate:', 72, 'HeartRateField');
            uilabel(g, 'Text', '');

             % Labels for the headers.
            headerLabels = {'', 'Amplitude', 'Duration'};
            for i = 1:numel(headerLabels)
                uilabel(g, 'Text', headerLabels{i}, 'FontSize', 14);
            end

            % Create and configure labels and input fields.
            uilabel(g, 'Text', 'P Wave :');
            obj.addLabeledNumericField(g, 'P Wave:', 0.25, 'PWaveField');
            obj.addLabeledNumericField(g, 'P Wave:', 0.09, 'DPWaveField');

            uilabel(g, 'Text', 'Q Wave :');
            obj.addLabeledNumericField(g, 'Q Wave:', 0.025, 'QWaveField');
            obj.addLabeledNumericField(g, 'Q Wave:', 0.066, 'DQWaveField');

            uilabel(g, 'Text', 'QRS :');
            obj.addLabeledNumericField(g, 'QRS:', 1.4, 'QRSField');
            obj.addLabeledNumericField(g, 'QRS:', 0.11, 'DQRSField');

            uilabel(g, 'Text', 'S Wave :');
            obj.addLabeledNumericField(g, 'S Wave:', 0.25, 'SWaveField');
            obj.addLabeledNumericField(g, 'S Wave:', 0.066, 'DSWaveField');

            uilabel(g, 'Text', 'T Wave :');
            obj.addLabeledNumericField(g, 'T Wave:', 0.35, 'TWaveField');
            obj.addLabeledNumericField(g, 'T Wave:', 0.142, 'DTWaveField');

            uilabel(g, 'Text', 'U Wave :');
            obj.addLabeledNumericField(g, 'U Wave:', 0.035, 'UWaveField');
            obj.addLabeledNumericField(g, 'U Wave:', 0.0476, 'DUWaveField');
            
            % Create button.
            uibutton( ...
                'Parent', columnLayout, ...
                'Text', 'Generate ECG', 'BackgroundColor', [0, 0, 0], ...
                'FontColor', [1, 1, 1], 'FontSize', 14, 'FontWeight', 'Bold', ...
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

            container = uigridlayout(parent, 'RowHeight', "1x", 'ColumnWidth', {"fit"}, 'Padding', 0, 'BackgroundColor', [0.8, 0.8, 0.8]);
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
