(function () {

    if ($('._2fug').length === 0) {
        return;
    }

    $(document).on("click", "input[type='file']", function () {
        alert("To upload media, drag and drop the file into the Messenger window.");
    });

}());