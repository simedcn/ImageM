function varargout = ImageM(varargin)
%IMAGEM Run a new instance of ImageM application
%
%   ImageM
%   Creates a new ImageM window, with a menu and without image.
%
%   ImageM(IMG)
%   Creates a new ImagM window initialized with the given image. IMG should
%   be an instance of Image Object.
%
%   Example
%     img = Image.read('cameraman.tif');
%     ImageM(img);
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

import imagem.app.ImagemApp;
import imagem.app.ImagemDoc;
import imagem.gui.ImagemGUI;
import imagem.gui.PlanarImageViewer;
import imagem.gui.actions.SayHelloAction;

% check if image is present, or create one
img = [];
if ~isempty(varargin)
    img = varargin{1};
end

app = ImagemApp;
gui = ImagemGUI(app);


% create a new figure for displaying image
doc = ImagemDoc(img);
PlanarImageViewer(gui, doc);

% action = SayHelloAction(gui, 'sayHello');
% 

if nargout > 0
    varargout = {gui};
end
