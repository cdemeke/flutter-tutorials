import 'package:flutter/material.dart';
import '../utils/question.dart';
import '../utils/quiz.dart';

import '../ui/answer_button.dart';
import '../ui/question_text.dart';
import '../ui/correct_wrong_overlay.dart';
import './score_page.dart';

class QuizPage extends StatefulWidget{
  @override
  State createState() => new QuizPageState();

}

class QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Is Elon Musk is human?", false),
    new Question("Is pizza healthy?", false),
    new Question("Flutter is awesome?", true),
  ]);
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState(){
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText =currentQuestion.question;
    questionNumber =quiz.questionNumber;
  }

  void handleAnswer(bool answer){
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState((){
      overlayShouldBeVisible = true;
    });
  }


  @override
  Widget build(BuildContext contetx){
    return new Stack(
      fit:StackFit.expand,
      children: <Widget>[
        new Column( // This is our main page
        children: <Widget>[
          new AnswerButton(true, () => handleAnswer(true)),
          new QuestionText(questionText, questionNumber),
          new AnswerButton(false, () => handleAnswer(false)),
        ],
        ),
        overlayShouldBeVisible == true ? new CorrectWrongOverlay(
          isCorrect,
          (){
            if (quiz.length ==questionNumber){
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context)=> new ScorePage(quiz.score, quiz.length)), (Route route) => route == null);
              return;
            }
            currentQuestion = quiz.nextQuestion;
            this.setState((){
              overlayShouldBeVisible = false;
              questionText = currentQuestion.question;
              questionNumber = quiz.questionNumber;
            });
          }
        ) : new Container()
      ],
    );
  }

}