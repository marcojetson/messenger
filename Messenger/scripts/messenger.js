jQuery.noConflict();

var stylesheet = new StyleSheet();

var displayNone = {display: 'none'};

stylesheet
    .addBlock(new CssBlock('.page > ._1tuu.header._31rc', displayNone))
    .addBlock(new CssBlock('._3v_p > ._3v_x > ._210j > ._3v_v > ._3v_w > ._59h8', displayNone))
    .addBlock(new CssBlock('._3v_p > ._3v_x > ._210j > ._3v_-', displayNone))
    .addBlock(new CssBlock('body > ._3v_p > ._3w04', displayNone))
    .addBlock(new CssBlock('._36ic._5vn4 > ._1tqi._4bl9', displayNone))
    .addBlock(new CssBlock('._4rv4._5vn4 > :first-child', displayNone))

    .addBlock(new CssBlock('._3v_p > ._3v_x > ._210j > ._3v_v', {
        display: 'block',
        margin: '0 auto',
        padding: 0
    }));

jQuery('<style>').html(stylesheet.toString()).appendTo('body');