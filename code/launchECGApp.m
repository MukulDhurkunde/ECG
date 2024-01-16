function varargout = launchECGApp(f)
%LAUNCHECGAPP Launch the ECG application.

arguments
    f(1, 1) matlab.ui.Figure = uifigure('WindowState', 'maximized')
end % arguments

% Rename figure.
f.Name = "ECG Simulator";

% Create the layout.
g = uigridlayout( ...
    "Parent", f, ...
    "RowHeight", {"1x", "fit"}, ...
    "ColumnWidth", {"1x", "fit"}, ...
    "Padding", 0 );

% Create the model.
m = Model();

% Create the view.
View( m, "Parent", g );

cg = uigridlayout( ...
     'Parent', g, ...
     'RowHeight', {"fit", 2, "fit", 2, "fit"}, ...
     'ColumnWidth', "1x", ...
     'Padding', 0, ...
     'BackgroundColor', [0.8, 0.8, 0.8]);

% Create the controllers.
PropertyController(m, "Parent", cg);
uilabel(cg, 'Text', '', 'BackgroundColor', 'white');
ArrhythmiaController(m, "Parent", cg);
uilabel(cg, 'Text', '', 'BackgroundColor', 'white');
NoiseController(m, "Parent", cg);

% Create toolbar to reset the model.
icon = fullfile( matlabroot, ...
"toolbox", "matlab", "icons", "tool_rotate_3d.png" ); 
tb = uitoolbar( "Parent", f );
uipushtool( ...
    "Parent", tb, ...
    "Icon", icon, ...
    "Tooltip", "Reset the data.", ...
    "ClickedCallback", @onReset );

    function onReset( ~, ~ )
        %ONRESET Callback function for the toolbar reset button.
        
        % Reset the model.
        reset( m )
        
    end % onReset

% Return the figure handle if requested.
if nargout > 0
    nargoutchk( 1, 1 )
    varargout{1} = f;
end % if

end