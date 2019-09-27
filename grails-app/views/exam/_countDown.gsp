<div class="count-down"></div>

<script>
    $(document).ready(function () {
        var clock = $('.count-down').FlipClock(3600 * ${remainingTime.hours} +60 * ${remainingTime.minutes} + ${remainingTime.seconds}, {
            countdown: true,
            clockFace: 'HourlyCounter'
        });
        window.setTimeout(function () {
            console.log("DONE");
        }, (60 * ${remainingTime.minutes} + ${remainingTime.seconds}) * 1000);
    })
</script>