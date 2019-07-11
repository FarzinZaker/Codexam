<div class="count-down"></div>

<script>
    $(document).ready(function () {
        var clock = $('.count-down').FlipClock(60 * ${timeLimit}, {
            countdown: true,
            clockFace: 'MinuteCounter'
        });
        window.setTimeout(function () {
            console.log("DONE");
        }, 60 * ${timeLimit/16} * 1000);
    })
</script>