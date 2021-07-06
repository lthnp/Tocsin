<script>
    $(document).ready(function () {
        @foreach(App\News::all() as $newsList)
        $("#findBtn")
        @endforeach
    });
</script>
