//ref: HeyFlutter․com https://youtu.be/LoDtxRkGDTw
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/model/event.dart';
import 'package:flutter_application_1/provider/event_provider.dart';
import 'package:flutter_application_1/utils.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage(
    {Key? key, this.event}) :super(key: key);

  @override 
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _form = GlobalKey<FormState>();

  //Map<String, List> mySelectedEvents = {};

  final titlectl = TextEditingController();
  final descriptionctl = TextEditingController();

  late DateTime fromDate;
  late DateTime toDate;


  @override
  void initState() {
    super.initState();

    if(widget.event == null){ // widget.event = event(การคลิ๊กปุ่มต่างๆ) ที่เกิดกับ widget 
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }else{
      final event = widget.event!;

      titlectl.text = event.addEvents;
      descriptionctl.text = event.description;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose(){
    titlectl.dispose();
    descriptionctl.dispose();

    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 236, 131, 166),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), //ปุ่มกดกลับ
          onPressed: () {
            Navigator.pop(context);
          },
          ),
          actions: buildEditingActions(),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              buildTitle(),
              buildDescription(),
              buildDateTimePicker(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() =>[ //ปุ่ม save
    ElevatedButton.icon(
      style:ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 236, 131, 166),
              shadowColor: Colors.transparent
            ),
      icon: Icon(Icons.done), 
      label: Text('Save'),
      onPressed: saveForm,
      ),
  ];

  Widget buildTitle() => TextFormField(
    controller: titlectl,
    decoration: const InputDecoration(
      icon: Icon(Icons.list_alt),
      labelText: 'Add Event',
      labelStyle: TextStyle(
      color: Color(0xFF6200EE),
       ),
      enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF6200EE)),
      ),
      ),
      onFieldSubmitted: (_) => saveForm(), //เมื่อกด enter หรือ save จะไปที่ function saveForm
      validator: (title) => title != null && title.isEmpty ? "Events cannot be empty" :null,//ถ้า title=null => "Title cannot be empty"
  );

  Widget buildDescription() => TextFormField(
    controller: descriptionctl,
    decoration: const InputDecoration(
      icon: Icon(Icons.description),
      labelText: 'Description',
      labelStyle: TextStyle(
      color: Color(0xFF6200EE),
       ),
      enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF6200EE)),
      ),
      ),
      onFieldSubmitted: (_) => saveForm(),
      
  );

  Widget buildDateTimePicker() => Column(
    children: [
      buildFrom(),
      SizedBox(height: 10.0),
      buildTo(),
    ],
  );

  Widget buildFrom() => buildHeader(
    header: 'From',
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(
            text: Utils.toDate(fromDate),
            onClicked: () => pickFromDateTime(pickDate: true),
          ) 
        ),
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(fromDate),
            onClicked: () => pickFromDateTime(pickDate: false),
          )
        )
      ],
    ),
  );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if(date == null) return;

    if(date.isAfter(toDate)) {
      toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() => fromDate = date);
  }

  Future<DateTime?> pickDateTime (
    DateTime initialDate, {
      required bool pickDate,
      DateTime? firstDate,
    }
  ) async {
    if(pickDate) {
      final date = await showDatePicker( //if pickDate True ให้ date showDatePicker
        context: context, 
        initialDate: initialDate, 
        firstDate: firstDate?? DateTime(2019), 
        lastDate: DateTime(2030),
        );
        if(date == null) return null;

        final time = Duration(
          hours: initialDate.hour,
          minutes: initialDate.minute
        );

        return date.add(time);

    }else {
      final timeOfDay = await showTimePicker( //if pickDate false ให้ timeOfDay showTimePicker
        context: context, 
        initialTime: TimeOfDay.fromDateTime(initialDate), 
        );
        
        if(timeOfDay == null) return null;

        final date = DateTime(
          initialDate.year,
          initialDate.month,
          initialDate.day
          );
        final time = Duration(
          hours: timeOfDay.hour,
          minutes: timeOfDay.minute
        );
        return date.add(time);
    }
  }

  Widget buildTo() => buildHeader(
    header: "To",
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(
            text: Utils.toDate(toDate), 
            onClicked: () => pickToDateTime(pickDate: true),)
            ),
        Expanded(
          
          child: buildDropdownField(
            text: Utils.toTime(toDate), 
            onClicked: () => pickToDateTime(pickDate: false),)
            )
      ],
    ),
  );

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isBefore(fromDate)) {
      fromDate = DateTime(date.year, date.month, date.day, fromDate.hour, fromDate.minute);
    }
    setState(() => toDate = date);
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
  ListTile(
    title: Text(text),
    trailing: Icon(Icons.arrow_drop_down),
    onTap: onClicked,
  );

  Widget buildHeader({
    required String header, //header กับ child ต้องไม่ null
    required Widget child,
  }) =>
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        header, style: TextStyle(fontWeight: FontWeight.bold) 
      ),
      child,//ใส่อันนี้จะมองเห็น child ที่กำหนด 
    ],
  );

  Future saveForm() async{
  final isValid = _form.currentState!.validate();

  if(isValid){
    final event = Event(
      addEvents: titlectl.text,
      description: descriptionctl.text,
      from: fromDate,
      to: toDate,
    );

    final isEditing = widget.event != null;
    final provider = Provider.of<EventProvider>(context, listen: false);
    if(isEditing){
      provider.editEvent(event, widget.event!);// event= new event, widget.event= old event

    }else{
      provider.addEvent(event); 
    }
    Navigator.of(context).pop(); //หลังจากกด save มันจะออกให้
  }}
}