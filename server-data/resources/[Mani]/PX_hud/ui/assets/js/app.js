var toggle = false

$(document).ready(function () {
    HealthIndicator = new ProgressBar.Circle("#HealthIndicator", {
      color: "rgb(0, 182, 91)",
      trailColor: "green",
      strokeWidth: 10,
      trailWidth: 10,
      duration: 250,
      easing: "easeInOut",
    });
  
    ArmorIndicator = new ProgressBar.Circle("#ArmorIndicator", {
      color: "rgb(255, 0, 0)",
      trailColor: "rgb(124, 50, 50)",
      strokeWidth: 10,
      trailWidth: 10,
      duration: 250,
      easing: "easeInOut",
    });
  
    HungerIndicator = new ProgressBar.Circle("#HungerIndicator", {
      color: "rgb(255, 164, 59)",
      trailColor: "rgb(165, 116, 60)",
      strokeWidth: 10,
      trailWidth: 10,
      duration: 250,
      easing: "easeInOut",
    });
  
    ThirstIndicator = new ProgressBar.Circle("#ThirstIndicator", {
      color: "rgb(0, 140, 255)",
      trailColor: "rgb(0, 85, 155)",
      strokeWidth: 10,
      trailWidth: 10,
      duration: 250,
      easing: "easeInOut",
    });
  
    StressIndicator = new ProgressBar.Circle("#StressIndicator", {
      color: "rgb(255, 74, 104)",
      trailColor: "rgb(102, 27, 40)",
      strokeWidth: 10,
      trailWidth: 10,
      duration: 250,
      easing: "easeInOut",
    });
  
    OxygenIndicator = new ProgressBar.Circle("#OxygenIndicator", {
      color: "rgb(0, 140, 255)",
      trailColor: "rgb(0, 85, 155)",
      strokeWidth: 10,
      trailWidth: 10,
      duration: 250,
      easing: "easeInOut",
    });
});
  
  window.addEventListener("message", function (event) {
    let data = event.data;
  
    if (data.action == "update_hud") {
      HealthIndicator.animate(data.hp / 100);
      ArmorIndicator.animate(data.armor / 100);
      HungerIndicator.animate(data.hunger / 100);
      ThirstIndicator.animate(data.thirst / 100);
      StressIndicator.animate(data.stress / 100);
      OxygenIndicator.animate(data.oxygen / 100);
    }
  
    // Change color and icon if HP is 0 (dead)
    if (data.hp < 0) {
      HealthIndicator.animate(0);
      HealthIndicator.trail.setAttribute("stroke", "red");
      $("#hp-icon").removeClass("fa-heart");
      $("#hp-icon").addClass("fa-skull");
    } else if (data.hp > 0) {
      HealthIndicator.trail.setAttribute("stroke", "green");
      $("#hp-icon").removeClass("fa-skull");
      $("#hp-icon").addClass("fa-heart");
    }
  
    // Flash if thirst is low
    if (data.thirst < 25) {
      $("#ThirstIcon").toggleClass("flash");
    }
    // Flash if hunger is low
    if (data.hunger < 25) {
      $("#HungerIcon").toggleClass("flash");
    }
  
    if (data.showUi == true) {
      $(".container").show();
    } else if (data.showUi == false) {
      $(".container").hide();
    }
  
    if (data.action == "toggle_hud") {
      $("body").fadeToggle()
    }
  });
  