jQuery ->
  if $('#infinite-scrolling').length > 0
    $(window).on 'scroll', ->
      more_posts_url = $('#infinite-scrolling .next_page a').attr('href')
      if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 20
        $(' .pagination').html(
          '<img src="assets/load.gif" alt="Loading..." title="Loading..." />')
        $.getScript more_posts_url
      return
    return
