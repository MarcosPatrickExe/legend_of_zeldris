extends Control;
onready var backBtn = $backButton;
onready var textInput = $comment_panel/TextEdit;
onready var commentScene = preload("res://scenes/CommentTemplate.tscn");
onready var commentVContainer = $chat_panel/ScrollContainer/VBoxContainer;
onready var shadowOfUserWindow = $shadow_for_dialog;
var userName :String = "";
var ableToShow :bool = false;
var abletoHide :bool = false;
var styleboxPanel;



func _ready():
	self.backBtn.connect("pressed", self, "backBtnPressed");
	self.styleboxPanel = self.shadowOfUserWindow.get_stylebox("panel", "");
	self.styleboxPanel.bg_color.a = 0 ;
	


func _process(delta :float) -> void:
	
	if( (self.userName =="") && !$create_user_window.visible ):
		ableToShow = true;
		self.shadowOfUserWindow.visible = true;
		$create_user_window.popup_centered(); #abre a janela de criar usuario


	if(ableToShow): # Ativando efeito fade-in
		self.styleboxPanel.bg_color.a += delta;
		
		if(self.styleboxPanel.bg_color.a >= 0.8224):
			self.ableToShow = false;
			
			
	elif(abletoHide): # Ativando efeito fade-out
		self.styleboxPanel.bg_color.a -= delta;
		
		if(self.styleboxPanel.bg_color.a <= 0.0):
			self.abletoHide = false;
			self.shadowOfUserWindow.visible = false;



func backBtnPressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn");


func _on_clearCommentBtn_pressed():
	self.textInput.text = "";


func _on_sendBtn_pressed(): #botao de enviar comentario
	var commentSceneInstance = self.commentScene.instance();
	
	commentSceneInstance.init(
		self.textInput.text,
		self.userName,
		$create_user_window/image_section_background/image_uploaded.texture
	);
	
	self.textInput.text = "";
	self.commentVContainer.add_child(commentSceneInstance);



func _on_confirm_btn_pressed(): # botao de confirmar nome (janela de criar usuario)
	 self.userName = $create_user_window/nickname_section_background/input_name.text;
	 var textureModel =  $create_user_window/image_section_background/image_uploaded.texture;
	
	 if(self.userName.length() > 0):
	   $user_profile_panel/userNameEditable.text = self.userName;
	   $user_profile_panel/profile_image.material.set_shader_param("profileImage", textureModel);
	   $create_user_window.visible = false;
	 else:
	   $create_user_window/nickname_section_background/warning_name.text = "O campo nome não pode estar vazio!!";
	
	
func _on_create_user_window_popup_hide(): # evento executado toda vez que a janela de criar usuario for fechada
	  self.abletoHide = true;


func _on_input_name_text_changed(new_text :String):
	 if(new_text == ""):
	   $create_user_window/nickname_section_background/warning_name.text = "Nome não pode ser vazio!!";
	
	 elif(new_text.length() > 0):
	   $create_user_window/nickname_section_background/warning_name.text = "";




func _on_comment_panel_gui_input(event :InputEvent): # evento emitido apos clique do mouse na area de inserir comentario
	 
	if event is InputEventMouseButton:
		print("clicou com o mouse", InputEventMouseButton.new().get_button_index());
	
	

func _on_send_image_btn_pressed(): #botao de enviar imagem
	 $uploadFileWindow.popup_centered();



func _on_uploadFileWindow_file_selected(path :String): #imagem selecionada
	
	var image =  Image.new();
	image.load(path);
	image.resize(450, 450, 0);
	var imageName = path.split("/", false, 0);# delimitador "/", false (nao permite espacos), n de divisoes maximas 
	
	var texture = ImageTexture.new();
	texture.create_from_image(image);
	
	$create_user_window/image_section_background/name_image_uploaded.text = imageName[ imageName.size()-1 ] # .trim_suffix(".png");
	$create_user_window/image_section_background/image_uploaded.texture = texture;


