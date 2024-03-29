extends Panel;
var shaderResource = preload("res://shaders/CommentTemplate.gdshader");


func init(comment: String, userName :String, profileImageTexture :Texture) -> void:
	var dataMask :String = "D-M-Y / H:m";
	
	var date :Dictionary = Time.get_datetime_dict_from_system(false);  #OS.get_datetime(false); #deprecated!!
	
	dataMask = dataMask.replace("D", str("0",date["day"]) if date["day"]<10 else date["day"]  );
	dataMask = dataMask.replace("M", str("0",date["month"]) if date["month"]<10 else date["month"]  );
	dataMask = dataMask.replace("Y", str("0",date["year"]) if date["year"]<10 else date["year"]  );
	dataMask = dataMask.replace("H", str("0",date["hour"]) if date["hour"]<10 else date["hour"]  );
	dataMask = dataMask.replace("m", str("0",date["minute"]) if date["minute"]<10 else date["minute"]  );
	
	
	$profile_name.text = userName;
	$date_and_hour_text.text = dataMask;
	$commentText.text = comment;
	
	var newMaterial = ShaderMaterial.new();
	newMaterial.shader = self.shaderResource;
	newMaterial.set_shader_param("scale", Vector2(1, 1));
	newMaterial.set_shader_param("offset", Vector2(0.008, 0.008));
	newMaterial.set_shader_param("profileImage", profileImageTexture);
	
	
	$profileImage.set_material( newMaterial);
