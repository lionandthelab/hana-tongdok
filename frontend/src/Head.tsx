import * as React from 'react';
import { Button } from '@material-ui/core';

interface IProps {
    name?: string;
}

const Head: React.FC<IProps> = (props: IProps) => 
    <div id="HomeTitle" >
        <h1>This is Head</h1>
    </div>

Head.defaultProps = {
    name: 'world',
};

export default Head;
