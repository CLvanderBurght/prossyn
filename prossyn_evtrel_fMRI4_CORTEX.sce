# 		ProsSyn 
# 		van der Burght 
#		27.04.2016

#		IMPORTANT:
# 		In this version of experiment: "yes" answer option = Left response button
# 		to be counter balanced between-subjects with "right" version scenario

#	Header
 
scenario = "audio";
#scenario_type = fMRI_emulation; # for emulation only
scenario_type =  fMRI;
scan_period = 2000;
pulses_per_scan = 1;

screen_width = 1024;
screen_height = 768;
screen_bit_depth = 32;
response_matching = simple_matching; # matches response to stimulus
active_buttons = 2;
button_codes = 1, 2;
pulse_code = 33; # identifies pulses in the logfile
response_logging = log_active;
no_logfile = false;

default_trial_duration = stimuli_length; 	
default_trial_type = fixed; 
default_font = "Arial";
default_font_size = 55;
default_text_color = 192, 192, 192;
default_background_color = 50, 50, 50; # grey

default_monitor_sounds = true; # ensures trial only ends when stimulus has finished playing. 

#	Begin

begin;

picture {} default; 

# define the different trials used in the experiment

trial {
	trial_type = fixed; 
	trial_duration = 5000; 
	picture {
	text {caption = "Sie werden mehrere Sätze anhören.\n\n\nNach jedem Satz wird eine Frage\nüber den Inhalt des Satzes gestellt\n\n\nDie Frage kann mit 'ja' oder 'nein' beantwortet werden.\nDrücken Sie bitte die richtige Taste.";
	font_size = 20; font_color = 255,255,255;}; x = 0; y = 80;
	text {caption = "Das Experiment fängt bald an.";
	font_size = 20; font_color = 255,255,0;}; x = 0; y = -220;
	}picture_welcome1; 
	code = "intro1";
	}trial_intro1;
	
trial {
	trial_type = fixed; 
	trial_duration = 1000; 
	picture {
	text {caption = "Sie werden mehrere Sätze anhören.\n\n\nNach jedem Satz wird eine Frage\nüber den Inhalt des Satzes gestellt\n\n\nDie Frage kann mit 'ja' oder 'nein' beantwortet werden.\nDrücken Sie bitte die richtige Taste.";
	font_size = 20; font_color = 255,255,255;}; x = 0; y = 80;
	text {caption = "Das Experiment fängt bald an.";
	font_size = 20; font_color = 255,255,0;}; x = 0; y = -220;
	}picture_welcome2; 
	code = "intro2";
	}trial_intro2;

trial {
	trial_type = fixed;
	trial_duration = 195;
	stimulus_event {
	picture {
	text { caption = "+";
	font_color = 255, 0, 0; font_size = 60;}alert_text; x = 0; y = 0;
	}alert_picture;
	code = "alert";
	}alert_event;
	}alert_trial;

trial {
	trial_type = fixed;
	trial_duration = 9000;
	stimulus_event { 
	picture {
	text { caption = "+";
	font_color = 255, 255, 255; font_size = 60;}null_text; x = 0; y = 0;
	}null_picture;
	code = "null";
	}null_event;
	}null_trial;

trial {
	#trial_type = fixed;
	trial_duration = stimuli_length;
	stimulus_event { 
	picture {
	text { caption = "+";
	font_color = 255, 255, 255; font_size = 60;}jitter_text; x = 0; y = 0;
	}jitter_picture;
	}jitter_event;
	}jitter_trial;

trial {
	trial_duration = stimuli_length;
	stimulus_event {
	sound {
	wavefile {
	filename = ""; 
	preload = false; ####
	}sound_file;
	}sound_sound;
	}sound_event;
	stimulus_event {
	picture {
	text { caption = "+";
	font_color = 255, 0, 0; font_size = 60;}clear_text; x = 0; y = 0;
	}clear_picture;
	}clear_event;
	}sound_trial;
	
trial {
	trial_duration = 1500;
	stimulus_event {
	picture {
	text { caption = " ";
	font_color = 255, 255, 255; font_size = 30;}question_text; x = 0; y = 0;
	text { caption = "ja   nein";
	font_color = 255, 255, 255; font_size = 30;}janein_text; x = 0; y = -200;
	}question_picture;
	}question_event;	
	}question_trial;

trial {
	trial_type = fixed;
	trial_duration = 1450;
	stimulus_event { 
	picture {
	text { caption = "+";
	font_color = 255, 255, 255; font_size = 60;}posttrial_text; x = 0; y = 0;
	}posttrial_picture;
	code = "post";
	}posttrial_event;
	}posttrial_trial;

trial {
	trial_type = fixed; 
	trial_duration = 6000;
	start_delay = 3000;
	picture {
	text {caption = "Das war der letzte Satz.\n\n\.Vielen Dank für Ihre Teilnahme."; 
	font_size = 30; font_color = 255,255,255;}; x = 0; y = 0;
	}picture_danke;
	code = "Danke"; 
	}trial_danke;

### ### ###	
	
#	PCL part of experiment

begin_pcl;

int button_count; 
int button_count_start; 

#	STIMULUS array_definition
#	input = participant array 

input_file stimuli_file = new input_file;
stimuli_file.open("fMRI_vp1_qnum_con_awk_jit_0_que_arr.txt");

array <string> arr_lista[300][20];
stimuli_file.set_delimiter(';');


loop int a = 1 until a > 300
begin

      loop int b = 1 until b > 20
      begin
     
				stimuli_file.set_delimiter(';');
				arr_lista[a][b] = stimuli_file.get_line();
				stimuli_file.set_delimiter(';');
		b = b + 1;
		end;
		
a = a + 1;
end;

stimuli_file.close();

trial_intro1.present ();

# waiting for pulse 5 (experiment begins after the first 5 volumes are collected)

int trigger = 5;
loop until
	(pulse_manager.main_pulse_count() >= trigger)
	begin
	trial_intro2.present ();
	end;



	loop int line = 1; until line > 300
	begin

			# parameters to define: question code, question_caption, sound_filename, jitter

			loop int column = 1; until column > 20
			begin

			sound_event.set_event_code(arr_lista[line][15]);
			question_event.set_event_code(arr_lista[line][17]);

			# writes the comprehension question of current trial
			question_text.set_caption(arr_lista[line][20]);
			question_text.redraw();

			# sets the auditory stimulus of current trial
			sound_file.unload();
			sound_file.set_filename(arr_lista[line][14]);
			sound_file.load();
			
			# sets the jitter duration of the current trial
			int jitter = int(arr_lista[line][18]);
			string jitterstr = (arr_lista[line][18]);
			jitter_event.set_duration(jitter);
			jitter_event.set_event_code("jitter" + jitterstr);
			
			int null = int(arr_lista[line][19]);
			
			column = column + 1;
			end;
		
		# null trials in stimulus arrays are marked with 0000 or 9999
		# any trial marked with 9999 will be preceded by a null trial
		int null = int(arr_lista[line][19]);

		if (null > 0) then
			null_trial.present ();
			jitter_trial.present ();		
			alert_trial.present ();
			sound_trial.present ();
			question_trial.present ();
			posttrial_trial.present ();
			
			line = line + 1;
		
		else
			jitter_trial.present ();		
			alert_trial.present ();
			sound_trial.present ();
			question_trial.present ();
			posttrial_trial.present ();
			
			line = line + 1;
		end			
		
	
	end;
	

trial_danke.present ();



