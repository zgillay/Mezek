function varargout = ControllPanel(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @ControllPanel_OpeningFcn, ...
                       'gui_OutputFcn',  @ControllPanel_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
end


function ControllPanel_OpeningFcn(hObject, eventdata, handles, varargin)
   
    Mezek=varargin{1};
    set(handles.figure1,'Units','Pixel')
    pos=get(handles.figure1,'Position');
    pos(2)=50;
    pos(4)=(size(Mezek,1)+4)*30+30;
    set(handles.figure1,'Position',pos);
    
    % List of all mez
    for i=1:size(Mezek,1)
        handles.mez(i)=uicontrol('Style', 'checkbox','String',Mezek{i} ,...
           'Position', [150 pos(4)-15-i*30 170 30],'Value',1,'Callback',@Mez_Callback);        
    end
    i=i+1;
    handles.mez(i)=uicontrol('Style', 'checkbox','String','Select All' ,...
           'Position', [150 pos(4)-15-i*30 170 30],'Callback',@SelectMezek_Callback);
    i=i+1;
    handles.mez(i)=uicontrol('Style', 'checkbox','String','Deselect All' ,...
           'Position', [150 pos(4)-15-i*30 170 30],'Callback',@DeselectMezek_Callback);
 
    % List of all day
    for i=1:24
        handles.nap(i)=uicontrol('Style', 'checkbox','String',[num2str(i) '. nap'] ,...
           'Position', [320 pos(4)-15-i*30 170 30],'Value',1,'Callback',@Nap_Callback);        
    end
    i=i+1;
    handles.nap(i)=uicontrol('Style', 'checkbox','String','Select All' ,...
           'Position', [320 pos(4)-15-i*30 170 30],'Callback',@SelectNapok_Callback);
    i=i+1;
    handles.nap(i)=uicontrol('Style', 'checkbox','String','Deselect All' ,...
           'Position', [320 pos(4)-15-i*30 170 30],'Callback',@DeselectNapok_Callback);       
       

   % Szenzorok
   Szenzorok=varargin{2};
   for i=1:size(Szenzorok,2)
        handles.szenzorok(i)=uicontrol('Style', 'checkbox','String',Szenzorok{i} ,...
           'Position', [50 pos(4)-250-i*30 100 30],'Value',1);        
    end
    
    guidata(hObject, handles);
    uiwait(hObject);   
end



function varargout = ControllPanel_OutputFcn(hObject, eventdata, handles)  
    varargout{1} = handles.output;
    delete(hObject);
end


function figure1_CloseRequestFcn(hObject, eventdata, handles)
    try
        if isequal(get(hObject, 'waitstatus'), 'waiting')
            uiresume(hObject);
            handles.output.Ph=get(handles.checkbox_Ph,'value');
            handles.output.Vez=get(handles.checkbox_Vez,'value');
            handles.output.Kihagy3=get(handles.checkbox_Kihagy3,'value');
            handles.output.Drift=get(handles.checkbox_Drift,'value');
            handles.output.Atlagol=get(handles.checkbox_Atlagol,'value');
            
            for i=1:size(handles.mez,2)-2           
                handles.output.mez(i)=get(handles.mez(i),'Value');                
            end
            
            for i=1:size(handles.nap,2)-2          
                handles.output.nap(i)=get(handles.nap(i),'Value');                
            end
            
            for i=1:size(handles.szenzorok,2)
                handles.output.szenzorok(i)=get(handles.szenzorok(i),'Value');
            end
            
            
            guidata(hObject, handles);
            drawnow
        else
            delete(hObject);
        end
    catch ME
        MEError(ME);
    end
end


%Mezek
function SelectMezek_Callback(o,e)
    handles=guidata(o);
    for i=1:size(handles.mez,2)-1 
        set(handles.mez(i),'Value',1);
    end
end


function DeselectMezek_Callback(o,e)
    handles=guidata(o);
    for i=1:size(handles.mez,2) 
        set(handles.mez(i),'Value',0);
    end
end

function Mez_Callback(o,e)
    handles=guidata(o);
    i=size(handles.mez,2)-1;
    set(handles.mez(i),'Value',0);

end

% Napok
function SelectNapok_Callback(o,e)
    handles=guidata(o);
    for i=1:size(handles.nap,2)-1 
        set(handles.nap(i),'Value',1);
    end
end


function DeselectNapok_Callback(o,e)
    handles=guidata(o);
    for i=1:size(handles.nap,2) 
        set(handles.nap(i),'Value',0);
    end
end

function Nap_Callback(o,e)
    handles=guidata(o);
    i=size(handles.nap,2)-1;
    set(handles.nap(i),'Value',0);

end


function checkbox_Nyelv_Callback(hObject, eventdata, handles)
    if get(hObject,'Value')
        val=1;
    else
        val=0;
    end
    for i=1:size(handles.szenzorok,1)
        set(handles.szenzorok,'Value',val)
    end
end


function pushbutton1_Callback(hObject, eventdata, handles)
    figure1_CloseRequestFcn(handles.figure1, eventdata, handles)
end
