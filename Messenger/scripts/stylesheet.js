var StyleSheet = function () {
    this.blocks = [];
    return this;
};

StyleSheet.prototype.addBlock = function (block) {
    this.blocks.push(block);
    return this;
};

StyleSheet.prototype.toString = function () {
    return this.blocks.join("\n\n");
};

var CssBlock = function (selector, rules) {
    this.selector = selector;
    this.rules = rules;
    return this;
};

CssBlock.prototype.toString = function () {
    var string = this.selector + ' {\n';
    for (var rule in this.rules) {
        string += '    ' + rule + ': ' + this.rules[rule] + ';\n';
    }
    string += '}';
    
    return string;
};
