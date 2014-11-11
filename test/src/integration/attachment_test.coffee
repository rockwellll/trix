editorModule "Attachments", template: "editor_with_image"

testEditorManipulation "moving an image by drag and drop", (expectDocument) ->
  moveCursor direction: "right", times: 1, (coordinates) ->
    document.activeElement.querySelector("img").dispatchEvent(createEvent("click"))
    after 1, ->
      dragToCoordinates coordinates, ->
        expectDocument "a#{Trix.AttachmentPiece.OBJECT_REPLACEMENT_CHARACTER}b\n"

testEditorManipulation "resizing an image", (expectDocument) ->
  figure = document.activeElement.querySelector("figure.attachment.image")
  clickElement figure, ->
    ok handle = figure.querySelector(".resize-handle")

    mouseDownOnElementAndMove handle, 5, ->
      locationRangeOfAttachment = Trix.LocationRange.forLocationWithLength({index: 0, offset: 2}, 1)
      attributes = editor.document.getCommonAttributesAtLocationRange(locationRangeOfAttachment)
      equal attributes.width, 15
      ok attributes.height in [15,16]
      expectDocument "ab#{Trix.AttachmentPiece.OBJECT_REPLACEMENT_CHARACTER}\n"

testEditorManipulation "removing an image", (expectDocument) ->
  figure = document.activeElement.querySelector("figure.attachment.image")
  figure.dispatchEvent(createEvent("click"))
  closeButton = figure.querySelector(".remove")
  clickElement closeButton, ->
    expectDocument "ab\n"
