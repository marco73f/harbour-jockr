.pragma library

var favoritesMap = {};

function loadFavoritesMap(favorites) {
    for (var i = 0; favorites.count > i; i += 1) {
        favoritesMap[favorites.get(i).id] = true;
    }
}

function isFavorite(photoId) {
    if (favoritesMap[photoId]) {
        return true
    } else {
        return false
    }
};
