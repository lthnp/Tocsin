@extends('layouts.app')

@section('content')
    <div class="container">
        @if(count($newsLists) > 0)
            <div class="pt-4 pb-4">
                <h2 class="font-weight-bold">
                    News Lists <span class="text-red" style="font-size: 16px;">ทั้งหมด {{count($newsLists)}} รายการ</span>
                </h2>
            </div>
            <div class="pb-4 overflow-hidden">
                <div class="pt-2 w-50 float-left" id="status-filter">
                    Filter >
                    <span style="color: #999">
                        <a href="{{route('newslists')}}" class="filter filter-active" id="FT-All">All</a> |
                        <a href="{{route('newslists')}}/?status=Proofed" class="filter" id="FT-Proofed">Proofed</a> |
                        <a href="{{route('newslists')}}/?status=Waiting" class="filter" id="FT-Waiting">Waiting</a>
                    </span>
                </div>
                <div class="w-50 float-left">
{{--                    <form action="/" method="POST" role="search">--}}
{{--                        @csrf--}}
{{--                        <div class="input-group">--}}
{{--                            <input type="text" class="form-control" name="q" placeholder="Search users"> <span class="input-group-btn">--}}
{{--                                <button type="submit" class="btn btn-default">--}}
{{--                                    <i class="fas fa-search"></i>--}}
{{--                                </button>--}}
{{--                            </span>--}}
{{--                        </div>--}}
{{--                    </form>--}}
                    <input type="text" name="search_news" id="search" class="form-control rounded-50 w-50 float-right" placeholder="search for news" style="outline: none !important">
                    <div class="pt-2 pr-4 float-right" id="status-filter" style="color: #999">
                        <a href="{{ route('newslists', ['status' => request('status'), 'sort' => 'asc']) }}" class="filter sort-active" id="asc">ก่อนหน้า</a> |
                        <a href="{{ route('newslists', ['status' => request('status'), 'sort' => 'desc']) }}" class="filter " id="desc">ล่าสุด</a>
                    </div>
                </div>
            </div>
            <div class="card-body bg-white rounded shadow-sm overflow-auto pr-5 pl-4" style="clear:both;">
                <div class="d-flex flex-row bd-highlight mb-3 w-100">
                    <div class="col-w-10">Status</div>
{{--                    <div class="col-w-10">ID</div>--}}
                    <div class="col-w-40">Title</div>



                    <div class="col-w-25">Link</div>
                    <div class="col-w-20">Created_at</div>
                    <div class="col-w-5">Action</div>
                </div><hr>
                @foreach($newsLists as $newsList)
                    <div class="d-flex flex-row bd-highlight mb-3 pt-3 pb-3">
                        @if($newsList->status == "Waiting")
                            <div class="col-w-10 text-break text-red pr-1 font-weight-bold">
                        @elseif($newsList->status == "Proofed")
                            <div class="col-w-10 text-break text-success font-weight-bold">
                        @endif
                            {{$newsList->status}}
                        </div>
{{--                        <div class="col-w-10">{{$newsList->id}}</div>--}}
                        <a class="col-w-40 font-weight-bold text-dark text-decoration-none" href="{{route('viewnews', $newsList->id)}}">{{$newsList->title}}</a>
                        <a class="col-w-25 text-break text-dark" href="{{$newsList->link}}" target="_blank">{{$newsList->link}}</a>
                        <div class="col-w-20 text-break">{{$newsList->created_at}}</div>
                        <div class="col-w-5">
{{--                            <a href="{{ route('editbook', $newsList->id) }}" class="btn btn-outline-warning btn-rounded"><i class="far fa-edit"></i></a>--}}
                            <a href="{{ route('delnews', $newsList->id) }}" class="btn btn-outline-red btn-rounded" onclick="return confirm('Confirm Delete News ID : ' + {{$newsList->id}} + ' ?');">
                                <i class="far fa-trash-alt"></i>
                            </a>
                        </div>
                    </div>
                @endforeach
{{--                            {{'status : '.request('status')}}--}}
{{--                            {{request('sort')}}--}}
            </div>
        @else
            <div class="text-center p-4 m-auto">
                <h1 class="pb-3 font-weight-bold">ยังไม่มีข่าว</h1>
            </div>
        @endif
    </div>

    <script>
        var allFilter = document.getElementById("FT-All");
        var sort = document.getElementById("asc");

        @if(request('status') == '')
            var currentFilter = document.getElementById("FT-All");
        @elseif(request('status') == 'Proofed')
            var currentFilter = document.getElementById("FT-Proofed");
        @elseif(request('status') == 'Waiting')
            var currentFilter = document.getElementById("FT-Waiting");
        @endif

        allFilter.className = currentFilter.className.replace(" filter-active", "");
        currentFilter.className += " filter-active";


        @if(request('sort') == 'asc')
            var currentSort = document.getElementById("asc");

        @elseif(request('sort') == 'desc')
            var currentSort = document.getElementById("desc");

        @endif

        sort.className = currentSort.className.replace(" sort-active", "");
        currentSort.className += " sort-active";
    </script>
@endsection
