module.exports = function(output) {
    var obj = {
        _index: "entitylib",
        _type: "entity",
        _id: "Ob7UuJC1Q4W6sAXKvxSMPQ",
        _score: 1,
        _source: {
            full: {
                title: "test entity title",
                description: "test entity description"
            },
            summary: {
                title: "test entity title"
            }
        }
    };

    var el = {
        date: 1402998117,
        shards: 5,
        hits: []
    };

    for (var i=0;i<10;i++) {
        el.hits.push(obj);
    }

    return output(el);
};

