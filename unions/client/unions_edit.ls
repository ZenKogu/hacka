template \unionsEdit	-> union_edit_page type:\edit
template \unionsInsert  -> union_edit_page type:\insert

Template.unionsEdit.events	  =-> union_events type:\edit
Template.unionsInsert.events  =-> union_events type:\insert

U =-> Unions.findOne(_id:currentID!)

union_edit_page =(o)->	D \container,
		D \page-header, h2 U!?name||\Несуществует,
			small style:'padding-left:10px', ' Редактирование',
			edit_buttons!
		text_input {addon_text:\Название		name:\name    editable:\true, type:\text, value:U!?name}
		text_input {addon_text:\Описание		name:\text    editable:\true, type:\text, value:U!?text}
		text_input {addon_text:\Таги			name:\tags    editable:\true, type:\text, value:U!?tags}
		text_input {addon_text:\Участники	    name:\members editable:\true, type:\text, value:''}
		text_input {addon_text:'Ссылка на лого' name:\src	  editable:\true, type:\text, value:U!?src}
		error_message that if pageSession.get \ErrorMessage
		info_message  that if pageSession.get \InfoMessage

text_input =(o)-> D 'input-group input-group-section form-group',
	D \input-group-addon, o.addon_text
	div class:\input_element,
		div {class:'input-div form-control text-input', name:o.name, contenteditable:o.editable, type:o.type}, o.value

edit_buttons =-> div class:\btn-group style:'float:right',
	a class:'btn btn-success save', i class:'fa fa-save'
	a class:'btn btn-primary exit',  i class:'fa fa-remove'

link_edit_button =-> div class:\btn-group style:'float:right',
	a class:'btn btn-success save' href:"/unions/edit/#{currentID!}", i class:'fa fa-edit'

error_message =-> div class:'alert alert-danger alert-dismissible' role:\alert,
	button class:\close \data-dismiss :\alert, i class:'fa fa-close'
	strong 'Error. '
	it

info_message =-> div class:'alert alert-success alert-dismissible' role:\alert,
	button class:\close \data-dismiss :\alert, i class:'fa fa-close'
	strong 'Готово. '
	it
