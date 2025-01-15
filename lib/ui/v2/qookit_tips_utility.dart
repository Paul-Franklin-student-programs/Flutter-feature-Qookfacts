import 'dart:math';

class QookitTips{

  final List<String> cookingTips = [
    "Add a pinch of salt to enhance the sweetness of your baked goods.",
    "Use fresh herbs for a burst of flavor in your dishes.",
    "Let your meat rest after cooking to retain its juices.",
    "Use a sharp knife for safer and easier cutting.",
    "Add a splash of vinegar to your water when boiling eggs to make them easier to peel.",
    "Don't overcrowd the pan; give your food room to brown properly.",
    "For crispier cookies, chill the dough before baking.",
    "Use a meat thermometer to ensure perfectly cooked meat.",
    "Soak wooden skewers in water before grilling to prevent burning.",
    "Always taste as you cook to adjust flavors.",
    "Preheat your oven to ensure even cooking.",
    "Use parchment paper for easy cleanup and to prevent sticking.",
    "Store herbs in a glass of water in the fridge to keep them fresh longer.",
    "When baking, measure flour by weight for accuracy.",
    "Use citrus juice to brighten flavors in dressings and marinades.",
    "To prevent onions from causing tears, chill them before cutting.",
    "Always use a cutting board to protect your countertops.",
    "Use a microplane to finely grate citrus zest for flavor.",
    "Cook pasta in salted water for better flavor.",
    "Use cold butter for flakier pastry dough.",
    "Sear meat on high heat for a caramelized crust.",
    "Rest burgers for a few minutes before serving for juiciness.",
    "Whisk vinaigrettes in a jar for easy emulsification.",
    "For perfect pancakes, let the batter rest before cooking.",
    "Rinse quinoa before cooking to remove bitterness.",
    "Use vegetable peels for homemade vegetable broth.",
    "Add a bay leaf to soups and stews for extra flavor.",
    "To peel tomatoes easily, blanch them in boiling water first.",
    "Use a cast-iron skillet for better heat retention and flavor.",
    "Store cookies in an airtight container with a slice of bread to keep them soft.",
    "When making stock, roast bones for deeper flavor.",
    "Use a pastry brush to evenly coat food with oil or butter.",
    "Cook bacon in the oven for perfectly crispy strips.",
    "Use a kitchen scale for precise ingredient measurements.",
    "To soften brown sugar, place a slice of bread in the container.",
    "Add a pinch of sugar to balance acidity in tomato sauces.",
    "Freeze fresh herbs in olive oil for easy use later.",
    "Use a coffee grinder to make powdered spices.",
    "To prevent browning, coat cut fruits with lemon juice.",
    "Add grated cheese to the top of casseroles for a crispy crust.",
    "Always preheat your frying oil to the right temperature.",
    "Use a cheesecloth to strain homemade stock for clarity.",
    "For fluffier omelets, add a splash of water before whisking.",
    "Sift flour before measuring for accurate results.",
    "Keep your knife sharp for safer and more efficient cutting.",
    "Use cooking spray to prevent sticking when baking.",
    "For a rich flavor, toast spices before using them.",
    "Add baking soda to your beans to reduce cooking time.",
    "Use a steamer basket for gentle cooking of vegetables.",
    "To enhance flavor, add a splash of soy sauce to stir-fries.",
    "Store spices in a cool, dark place for maximum freshness.",
    "Always check the expiration date on your ingredients.",
    "Marinate meats in an acid (like lemon juice) to tenderize.",
    "Use a zester to create citrus curls for garnishes.",
    "Add cream to tomato soup for a richer texture.",
    "For a quick salad dressing, shake olive oil and vinegar in a jar.",
    "Use a pizza stone for better crust when baking pizza.",
    "To thicken soups, blend a portion of the mixture and return it to the pot.",
    "Use a whisk to aerate cream for better whipping.",
    "Experiment with flavored salts for a twist on seasoning.",
    "To make homemade breadcrumbs, pulse stale bread in a food processor.",
    "Incorporate yogurt into dressings for creaminess without excess fat.",
    "Use a timer to avoid overcooking your food.",
    "To keep cakes moist, use simple syrup when assembling layers.",
    "For a unique twist, add a splash of whiskey to BBQ sauce.",
    "Cook rice in broth instead of water for added flavor.",
    "Add a dash of hot sauce to enhance the flavor of bean dishes.",
    "Use an ice cream scoop for uniform cookies.",
    "Store leftover wine in the freezer in ice cube trays for cooking.",
    "Use a meat mallet to tenderize tougher cuts of meat.",
    "To keep cookies from spreading, chill the dough before baking.",
    "Use a slow cooker for tender, flavorful meals with minimal effort.",
    "Add cheese rinds to soups for extra depth of flavor.",
    "Use a blender to puree soups for a smooth texture.",
    "When making mashed potatoes, use a potato ricer for fluffiness.",
    "Add a tablespoon of oil to pasta water to prevent sticking.",
    "When roasting vegetables, toss them in oil for even coverage.",
    "Use a double boiler for gentle melting of chocolate.",
    "Cut herbs with kitchen scissors for easy chopping.",
    "To prevent pasta from clumping, stir it frequently while cooking.",
    "Use fresh lemon zest to enhance baked goods.",
    "Add a splash of beer to batters for extra flavor.",
    "To tenderize beans, soak them overnight before cooking.",
    "Incorporate nuts into salads for added crunch.",
    "Use a meat thermometer to avoid undercooking poultry.",
    "Add a dash of cinnamon to chili for warmth.",
    "Use a potato peeler to create thin strips of vegetables for salads.",
    "Store flour in the refrigerator for longer shelf life.",
    "Add garlic to butter for a flavorful spread.",
    "To make homemade whipped cream, chill your bowl and beaters first.",
    "Use a roasting pan with a rack for even cooking of meats.",
    "Add a touch of honey to marinades for sweetness.",
    "Use a mandoline slicer for even cuts of vegetables.",
    "To prevent avocado from browning, keep the pit in the unused half.",
    "Add a splash of white wine to elevate pasta sauces.",
    "Use the starchy water from cooking pasta to thicken sauces.",
    "For a crunchy topping, mix breadcrumbs with parmesan cheese.",
    "Add sliced apples to salads for a sweet crunch.",
    "Use chicken stock in place of water for more flavorful rice.",
    "Incorporate seasonal fruits into your dishes for freshness.",
    "For softer tortillas, heat them in a pan before serving.",
    "Use a food processor to quickly chop large quantities of ingredients.",
    "Add a pinch of nutmeg to creamy sauces for warmth.",
    "Use a fish spatula to gently flip delicate items like fish.",
    "For even baking, rotate your baking sheet halfway through cooking.",
    "Add a splash of cream to scrambled eggs for richness.",
    "To make homemade pizza, use store-bought dough for convenience.",
    "Use a scale to measure pasta portions for consistent servings.",
    "To make your own taco seasoning, mix chili powder, cumin, and garlic powder.",
    "Use a cookie cutter to shape pancakes for fun breakfast presentations."
  ];

  String currentTip = "";

  String loadNewTip() {
    currentTip = cookingTips[Random().nextInt(cookingTips.length)];
    return currentTip;
  }
}