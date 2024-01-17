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

            uilabel(columnLayout, 'Text', 'ECG Properties', 'FontSize', 14, 'FontWeight', 'Bold');

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
            headerLabels = {'', 'Amplitude (mV)', 'Duration (s)'};
            for i = 1:numel(headerLabels)
                uilabel(g, 'Text', headerLabels{i}, 'FontSize', 12);
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

        end % setup

        function update(obj)
            obj.Model.Values.("heartRate") = obj.HeartRateField.Value;
            obj.Model.Values.aPwave = obj.PWaveField.Value;
            obj.Model.Values.aQwave = obj.QWaveField.Value;
            obj.Model.Values.aQRS = obj.QRSField.Value;
            obj.Model.Values.aSwave = obj.SWaveField.Value;
            obj.Model.Values.aTwave = obj.TWaveField.Value;
            obj.Model.Values.aUwave = obj.UWaveField.Value;
            obj.Model.Values.dPwave = obj.DPWaveField.Value;
            obj.Model.Values.dQwave = obj.DQWaveField.Value;
            obj.Model.Values.dQRS = obj.DQRSField.Value;
            obj.Model.Values.dSwave = obj.DSWaveField.Value;
            obj.Model.Values.dTwave = obj.DTWaveField.Value;
            obj.Model.Values.dUwave = obj.DUWaveField.Value;

        end % update

    end % methods (Access = protected)

    methods (Access = private)

        function addLabeledNumericField(obj, parent, labelText, defaultValue, fieldName)
            % Helper function to add a labeled numeric field.

            container = uigridlayout(parent, 'RowHeight', "1x", 'ColumnWidth', {"fit"}, 'Padding', 0, 'BackgroundColor', [0.8, 0.8, 0.8]);
            obj.(fieldName) = uieditfield(container, 'numeric', 'Value', defaultValue, 'Limits', [0, Inf], 'ValueChangedFcn', @(src, event) obj.validateInput(src, labelText, fieldName));
        end

        function validateInput(obj, src, labelText, fieldName)
            % Validate the input to ensure it is numeric.

            input = src.Value;

            if ~isnumeric(input) || ~isscalar(input)
                % Display an error message for invalid input.
                msg = sprintf('Invalid input value for %s. Please enter a numeric value.', labelText);
                errordlg(msg, 'Invalid Input', 'modal');

                % Reset the input field to its previous value.
                src.Value = src.Value;
            end

            if (strcmpi(fieldName, 'PWaveField'))
                obj.Model.Values.aPwave = input;
            elseif (strcmpi(fieldName, 'DPWaveField'))
                obj.Model.Values.dPwave = input;
            elseif (strcmpi(fieldName, 'QWaveField'))
                obj.Model.Values.aQwave = input;
            elseif (strcmpi(fieldName, 'DQWaveField'))
                obj.Model.Values.dQwave = input;
            elseif (strcmpi(fieldName, 'QRSField'))
                obj.Model.Values.aQRS = input;
            elseif (strcmpi(fieldName, 'DQRSField'))
                obj.Model.Values.dQRS = input;
            elseif (strcmpi(fieldName, 'SWaveField'))
                obj.Model.Values.aSwave = input;
            elseif (strcmpi(fieldName, 'DSWaveField'))
                obj.Model.Values.dSwave = input;
            elseif (strcmpi(fieldName, 'TWaveField'))
                obj.Model.Values.aTwave = input;
            elseif (strcmpi(fieldName, 'DTWaveField'))
                obj.Model.Values.dTwave = input;
            elseif (strcmpi(fieldName, 'UWaveField'))
                obj.Model.Values.aUwave = input;
            elseif (strcmpi(fieldName, 'DUWaveField'))
                obj.Model.Values.dUwave = input;
            elseif (strcmpi(fieldName, 'HeartRateField'))
                obj.Model.Values.heartRate = input;
            else
            end

        end % validateInput

    end % methods (Access = private)

end % classdef