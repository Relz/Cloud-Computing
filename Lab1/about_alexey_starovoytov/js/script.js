$(document).ready(function () {
  const anyLink = $("a");

  anyLink.click(function () {
    const elementClick = $(this).attr("href");
    if (elementClick !== undefined) {
      const destination = $(elementClick).offset().top;
      $("html").animate({ scrollTop: destination - 10 }, 1100);
    }
  });

  const onTopButton = $("#button_on_top");

  $(window).scroll(function () {
    if ($(window).scrollTop() > 500) {
      onTopButton.addClass("show");
    } else {
      onTopButton.removeClass("show");
    }
  });

  onTopButton.on("click", function (e) {
    e.preventDefault();
    $("html, body").animate({ scrollTop: 0 }, "400");
  });

  const mailButton = document.querySelector("#a_mail");

  mailButton.addEventListener("click", () => {
    navigator.clipboard.writeText("relz0071@gmail.com");
  });

  const phoneButton = document.querySelector("#a_phone");

  phoneButton.addEventListener("click", () => {
    navigator.clipboard.writeText("89876543210");
  });
});
