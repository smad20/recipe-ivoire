import 'package:flutter/cupertino.dart';
import 'package:flutter_recipee_app/model/Recipe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RecipeDataBase {
  RecipeDataBase._();
  static RecipeDataBase instance = RecipeDataBase._();

  static Database db;

  Future<Database> get database async {
    if (db = null) {
      return db;
    } else {
      db = await initDB();
      return db;
    }
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), "databases_recipe.db"),
      onCreate: (db, i) {
        return db.execute(
          "CREATE TABLE recipe(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, imgPath TEXT, time TEXT, isfavoriteCount INTEGRER, isFavorite INTEGRER)",
        );
      },
      version: 3,
    );
  }

  insertRecipe(Recipe recipe) async {
    final Database tdb = await database;
    await tdb.insert(
      "recipe",
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  updateRecipe(Recipe recipe) async {
    final Database tdb = await database;
    await tdb.update(
      "recipe",
      recipe.toMap(),
      where: "id=?",
      whereArgs: [recipe.id],
    );
  }

  deleteRecipe(int id) async {
    final Database tdb = await database;
    tdb.delete(
      "recipe",
      where: "id=?",
      whereArgs: [id],
    );
  }

  Future<List<Recipe>> recipes() async {
    final Database tdb = await database;
    List<Map<String, dynamic>> maps = await tdb.query("recipe");
    List<Recipe> recipes = List.generate(
      maps.length,
      (index) {
        return Recipe.fromMap(maps[index]);
      },
    );
    /* if (mesnotes.isEmpty) {
       for (MiniCont m in defaultNotes) {
         insertNote(m);
       }
       mesnotes = defaultNotes;
     }
    ON ELEVE LE RETOUR OBLIGATOIRE(POUR NE PAS QUE LES ELEMENTS PAR DEFAULT REAPPARAISSE UNE FOIS SUPPRIMER)
    */
    return recipes;
  }
}
