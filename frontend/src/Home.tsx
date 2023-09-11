import * as React from 'react';
import { Button } from '@material-ui/core';
interface IProps {
    name?: string;
}

const Home: React.FC<IProps> = (props: IProps) => 
    <div>
        <h1>hello</h1>
        <Button color="primary">Hello World</Button>
        <div>bye</div>
    </div>

Home.defaultProps = {
    name: 'world',
};

export default Home;
