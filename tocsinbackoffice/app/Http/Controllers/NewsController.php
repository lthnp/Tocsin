<?php

namespace App\Http\Controllers;

use App\Models\Amphure;
use App\Models\District;
use App\Models\Location;
use App\Models\News;
use App\Models\Province;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class NewsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $newsLists = new News();

        if(request()->has('status')){
            $newsLists = $newsLists->where('status', request('status'));
        }

        if (request()->has('sort')) {
            $newsLists = $newsLists->OrderBy('created_at', request('sort'));
        }

        $newsLists = $newsLists->get()->append([
            'status' => request('status'),
            'sort' => request('sort'),
        ]);


//        $newsLists = News::where('title','LIKE','%'.'น้'.'%')->get();

//        if(request()->has('status')){
//            $newsLists = News::where('status', request('status'))->get();
//        } elseif (request()->has('sort')) {
//            $newsLists = News::OrderBy('created_at', request('sort'))->get();
//        } else {
//            $newsLists = News::OrderBy('created_at', 'desc')->get();
//        }

        return view('newslists')->with('newsLists', $newsLists);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $selected_news = News::find($id);

        if($selected_news->status == 'Proofed'){
            $location = Location::Where('news_id', $id)->get();

            return view('viewnews')
                ->with('selected_news', $selected_news)
                ->with('locations', $location);
        }

        return view('viewnews')
            ->with('selected_news', $selected_news);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request)
    {
        $this->validate($request, [
            'news_id'=>'required',
        ]);

        $news = News::find($request->input('news_id'));
        $news->status = "Proofed";
        $news->save();

        return back()->with('success', 'Not Found Location');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $selected_news = News::find($id);
        $selected_news->delete();
        return redirect(route('newslists'))->with('success', 'Deleted News ID #'.$selected_news->id);
    }
}
