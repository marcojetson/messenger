jQuery.noConflict();

var stylesheet = new StyleSheet(),
    displayNone = {display: 'none'};

stylesheet

// login
.addBlock(new CssBlock('.page > ._1tuu.header._31rc', displayNone))

// login
.addBlock(new CssBlock('._3v_p > ._3v_x > ._210j > ._3v_v > ._3v_w > ._59h8', displayNone))

// login
.addBlock(new CssBlock('._3v_p > ._3v_x > ._210j > ._3v_-', displayNone))

// login
.addBlock(new CssBlock('body > ._3v_p > ._3w04', displayNone))

// login
.addBlock(new CssBlock('._4rv4._5vn4 > :first-child', displayNone))

// login
.addBlock(new CssBlock('._3v_p > ._3v_x > ._210j > ._3v_v', {
    display: 'block',
    margin: '0 auto',
    padding: 0
}))

// chat.sidebar.header.title
.addBlock(new CssBlock('._36ic._5vn4 > ._1tqi._4bl9', displayNone))

// chat.sidebar.header.cog.dropdown.items except first and last
.addBlock(new CssBlock('.uiContextualLayerPositioner ._256m > li:not(:first-child):not(:last-child)', displayNone))

// chat.settings.desktop_notifications
.addBlock(new CssBlock('[role=dialog] ._4eby._2c9i > ._374b:nth-child(4)', displayNone));

jQuery('<style>').html(stylesheet.toString()).appendTo('body');