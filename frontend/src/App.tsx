import React from 'react';
import logo from './logo.svg';
import Home from './Home';
import Head from './Head';
import Navigator from './Navigator';
import CurDate from './CurDate';
import Footer from './Footer';
import Body from './Body';

import './App.css';
import './Head.css';
import './CurDate.css';
import './Footer.css';
import './Navigator.css';
import './Body.css';

function App() {
    return (
        <div className="App">
            <Head />
            <div className="Horizon">
            <CurDate />
            <Navigator />
            </div>
            <Body />
            <Footer />
        </div>
    );
}

export default App;
