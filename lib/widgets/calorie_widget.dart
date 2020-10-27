import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Sex { MAN, WOMAN }
enum ActivityFactor { LOW, MODERATE, HIGH }
const COLOR_FOR_MAN = Colors.blue;
const COLOR_FOR_WOMAN = Colors.purple;

extension on Sex {
  String toShortString() => this.toString().split('.').last.toLowerCase();
}

extension on ActivityFactor {
  String toShortString() => this.toString().split('.').last.toLowerCase();
}

/// A Calorie calculator widget which extends to {StatelessWidget}.
class CalorieCalculator extends StatefulWidget {
  final String title;

  CalorieCalculator({Key key, this.title}) : super(key: key);

  @override
  _CalorieCalculatorState createState() => _CalorieCalculatorState();
}

/// A Calorie calculator State which extends to {State<CalorieCalculator>}.
class _CalorieCalculatorState extends State<CalorieCalculator> {
  // FIELDS --------------------------------------------------------------------
  Sex _currentSex = Sex.MAN;
  double _age;
  double _size;
  double _weight;
  ActivityFactor _activityFactor;

  // METHODS -------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
                backgroundColor: _getColorAccordingToSex()),
            body: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2.0,
                              margin: EdgeInsets.all(16.0),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _getText(Sex.WOMAN.toShortString(),
                                              COLOR_FOR_WOMAN),
                                          Switch(
                                              value: _isMan(),
                                              activeColor:
                                                  _getColorAccordingToSex(),
                                              onChanged: _actionToChangeSex),
                                          _getText(Sex.MAN.toShortString(),
                                              COLOR_FOR_MAN)
                                        ]),
                                    _getRaisedButton(
                                        (_age == null)
                                            ? 'Select your age'
                                            : 'Your age is ${_age.toStringAsFixed(0)}',
                                        _getColorAccordingToSex(),
                                        _actionToChangeAge),
                                    _getText(
                                        (_size == null)
                                            ? 'Select your Size'
                                            : 'Your size is ${_size.toStringAsFixed(1)}cm',
                                        _getColorAccordingToSex()),
                                    Slider(
                                        value: _size ?? 0.0,
                                        min: 0.0,
                                        max: 250,
                                        inactiveColor: Colors.grey,
                                        activeColor: _getColorAccordingToSex(),
                                        onChanged: _actionToChangeSize),
                                    TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText:
                                                "Enter your weight in kilos",
                                            labelStyle: TextStyle(
                                                color:
                                                    _getColorAccordingToSex())),
                                        onChanged: _actionToChangeWeight),
                                    _getText('What is your activity level?',
                                        _getColorAccordingToSex()),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _getRadio(ActivityFactor.LOW,
                                              _getColorAccordingToSex()),
                                          _getRadio(ActivityFactor.MODERATE,
                                              _getColorAccordingToSex()),
                                          _getRadio(ActivityFactor.HIGH,
                                              _getColorAccordingToSex())
                                        ]),
                                  ]))),
                      _getRaisedButton('Calculate', _getColorAccordingToSex(),
                          _actionToCalculateCalorie)
                    ]))));
  }

  // -- UI --

  Text _getText(String textData, Color color) {
    return Text(textData, style: TextStyle(color: color));
  }

  RaisedButton _getRaisedButton(String textData, Color color, Function action) {
    return RaisedButton(
        color: color,
        child: _getText(textData, Colors.white),
        onPressed: action);
  }

  Widget _getRadio(ActivityFactor activityFactor, Color color) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Radio(
          value: activityFactor,
          groupValue: _activityFactor,
          activeColor: color,
          onChanged: (ActivityFactor factor) =>
              setState(() => _activityFactor = factor)),
      _getText(activityFactor.toShortString(), color)
    ]);
  }

  // -- Action --

  void _actionToChangeSex(bool isMan) =>
      setState(() => _currentSex = (isMan) ? Sex.MAN : Sex.WOMAN);

  Future<Null> _actionToChangeAge() async {
    final DateTime currentDate = DateTime.now();

    final DateTime dateSelected = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(currentDate.year + 1),
        initialDatePickerMode: DatePickerMode.year);

    final int age = currentDate.year - dateSelected.year;

    if (dateSelected != null) setState(() => _age = age.toDouble());
  }

  void _actionToChangeSize(double size) => setState(() => _size = size);

  void _actionToChangeWeight(String weight) =>
      setState(() => _weight = double.tryParse(weight));

  void _actionToCalculateCalorie() {
    if (_age != null &&
        _size != null &&
        _weight != null &&
        _activityFactor != null) {
      _showCalorieDialog();
    } else {
      _showAlertDialog();
    }
  }

  // -- Dialog --

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
              title: _getText('Warning', Colors.black),
              contentPadding: EdgeInsets.all(16.0),
              content:
                  _getText('All parameters must be filled in!', Colors.black),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(buildContext),
                    child: _getText('Ok', _getColorAccordingToSex()))
              ]);
        });
  }

  Future<void> _showCalorieDialog() async {
    final result =
        _getCalories(_currentSex, _weight, _size, _age, _activityFactor);

    return showDialog<void>(
        context: context,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
              title: _getText('Result', Colors.black),
              contentPadding: EdgeInsets.all(16.0),
              children: [
                _getText("Calories = ${result.toStringAsFixed(2)}kCal",
                    Colors.black),
                Container(height: 20.0),
                _getRaisedButton('Ok', _getColorAccordingToSex(),
                    () => Navigator.pop(buildContext))
              ]);
        });
  }

  // -- SEX --

  bool _isMan() => (_currentSex == Sex.MAN) ? true : false;

  // -- Color --

  Color _getColorAccordingToSex() =>
      (_currentSex == Sex.MAN) ? COLOR_FOR_MAN : COLOR_FOR_WOMAN;

  // -- Calorie --

  double _getCalories(
      Sex sex, double weight, double size, double age, ActivityFactor factor) {
    double calories;
    switch (sex) {
      case Sex.MAN:
        calories =
            66.4730 + (13.7516 * weight) + (5.0033 * size) - (6.7550 * age);
        break;
      case Sex.WOMAN:
        calories =
            655.0955 + (9.5634 * weight) + (1.8496 * size) - (4.6756 * age);
    }

    return calories * _getFactorAccordingToActivity(factor);
  }

  // ignore: missing_return
  double _getFactorAccordingToActivity(ActivityFactor factor) {
    switch (factor) {
      case ActivityFactor.LOW:
        return 1.2;
      case ActivityFactor.MODERATE:
        return 1.5;
      case ActivityFactor.HIGH:
        return 1.8;
    }
  }
}