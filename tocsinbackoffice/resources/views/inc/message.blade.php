@if($errors->any())
    <div class="alert alert-danger alert-dismossible fade show" role="alert">
        <ul>
            @foreach($errors->all() as $error)
                <li>{{$error}}</li>
            @endforeach
        </ul>
        <button class="close" type="button" data-dismiss="alert">
            <span>x</span>
        </button>
    </div>
@endif

@if(session('success'))
    <div class="alert alert-success alert-dismossible fade show" role="alert">
        {{ session('success') }}
        <button class="close" type="button" data-dismiss="alert">
            <span>x</span>
        </button>
    </div>
@endif

