import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final fi = FirebaseFirestore.instance;

//FR - firestore reference

final userFR = fi.collection('users');
final quizePaperFR = fi.collection('quizpapers');
final leaderBoardFR = fi.collection('leaderboard');
final gameItemFR = fi.collection('itemstore');
final gameFR = fi.collection('games');

// quiz
DocumentReference recentQuizesData(
        {required String userId, required String paperId}) =>
    userFR.doc(userId).collection('myrecent_quizes').doc(paperId);

CollectionReference<Map<String, dynamic>> recentQuizes(
        {required String userId}) =>
    userFR.doc(userId).collection('myrecent_quizes');

CollectionReference<Map<String, dynamic>> getleaderBoard(
        {required String paperId}) =>
    leaderBoardFR.doc(paperId).collection('scores');

DocumentReference questionsFR(
        {required String paperId, required String questionsId}) =>
    quizePaperFR.doc(paperId).collection('questions').doc(questionsId);

// game
DocumentReference recentGamesData(
        {required String userId, required String paperId}) =>
    userFR.doc(userId).collection('myrecent_games').doc(paperId);

CollectionReference<Map<String, dynamic>> recentGames(
        {required String userId}) =>
    userFR.doc(userId).collection('myrecent_games');

CollectionReference<Map<String, dynamic>> getleaderBoardGame(
        {required String paperId}) =>
    leaderBoardFR.doc(paperId).collection('game_scores');

// game item store
CollectionReference<Map<String, dynamic>> getallItems() => gameItemFR;
DocumentReference gameItemFRDoc({required String id}) =>
    gameItemFR.doc(id);

// game store
CollectionReference<Map<String, dynamic>> getallGames() => gameFR;

DocumentReference gameFRDoc({required String id}) => gameFR.doc(id);  

//Reference get firebaseStorage => FirebaseStorage.instanceFor(bucket: 'gs://fire-base-chat-cc3e9.appspot.com').ref();
Reference get firebaseStorage => FirebaseStorage.instance.ref();
