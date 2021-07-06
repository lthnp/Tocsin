import 'package:Tocsin/Component/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTextFieldDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateChanged;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat dateFormat;
  final FocusNode focusNode;
  final String labelText;
  final Icon prefixIcon;
  final Icon suffixIcon;

  MyTextFieldDatePicker({
    Key key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.dateFormat,
    @required this.lastDate,
    @required this.firstDate,
    @required this.initialDate,
    @required this.onDateChanged,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(!initialDate.isBefore(firstDate),
        'initialDate must be on or after firstDate'),
        assert(!initialDate.isAfter(lastDate),
        'initialDate must be on or before lastDate'),
        assert(!firstDate.isAfter(lastDate),
        'lastDate must be on or after firstDate'),
        assert(onDateChanged != null, 'onDateChanged must not be null'),
        super(key: key);

  @override
  _MyTextFieldDatePicker createState() => _MyTextFieldDatePicker();
}

class _MyTextFieldDatePicker extends State<MyTextFieldDatePicker> {
  TextEditingController _controllerDate;
  DateFormat _dateFormat;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.dateFormat != null) {
      _dateFormat = widget.dateFormat;
    } else {
      _dateFormat = DateFormat.yMMMd();
    }

    _selectedDate = widget.initialDate;

    _controllerDate = TextEditingController();
    _controllerDate.text = _dateFormat.format(_selectedDate).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextField(
        focusNode: widget.focusNode,
        controller: _controllerDate,
        decoration: InputDecoration(
          icon: Icon(CustomIcons.calendar, color: Colors.black26, size: 16,),
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.black26),
          border: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.black26)
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.primary2)
          ),
        ),
        onTap: () => _selectDate(context),
        readOnly: true,
      ),
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate.text = _dateFormat.format(_selectedDate);
      widget.onDateChanged(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode.nextFocus();
    }
  }
}

class DatePickerEdit extends StatefulWidget {
  final ValueChanged<DateTime> onDateChanged;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat dateFormat;
  final FocusNode focusNode;
  final String labelText;
  final Icon prefixIcon;
  final Icon suffixIcon;

  DatePickerEdit({
    Key key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.dateFormat,
    @required this.lastDate,
    @required this.firstDate,
    @required this.initialDate,
    @required this.onDateChanged,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(!initialDate.isBefore(firstDate),
        'initialDate must be on or after firstDate'),
        assert(!initialDate.isAfter(lastDate),
        'initialDate must be on or before lastDate'),
        assert(!firstDate.isAfter(lastDate),
        'lastDate must be on or after firstDate'),
        assert(onDateChanged != null, 'onDateChanged must not be null'),
        super(key: key);

  @override
  _DatePickerEdit createState() => _DatePickerEdit();
}

class _DatePickerEdit extends State<DatePickerEdit> {
  TextEditingController _controllerDate;
  DateFormat _dateFormat;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.dateFormat != null) {
      _dateFormat = widget.dateFormat;
    } else {
      _dateFormat = DateFormat.yMMMd();
    }

    _selectedDate = widget.initialDate;

    _controllerDate = TextEditingController();
    _controllerDate.text = _dateFormat.format(_selectedDate).toString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: size.height*0.025),
      child: TextFormField(
        style: TextStyle(fontSize: 14),
        focusNode: widget.focusNode,
        controller: _controllerDate,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.black26, fontSize: 14),
          border: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.black26)
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.primary2)
          ),
        ),
        onTap: () => _selectDate(context),
        readOnly: true,
      ),
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate.text = _dateFormat.format(_selectedDate);
      widget.onDateChanged(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode.nextFocus();
    }
  }
}